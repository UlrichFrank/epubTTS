.PHONY: help clean build test run release format lint install-tools

# Colors for output
BOLD := \033[1m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
NC := \033[0m # No Color

help:
	@echo "$(BOLD)epubTTS - Project Makefile$(NC)"
	@echo ""
	@echo "$(BOLD)Available targets:$(NC)"
	@echo "  $(GREEN)make help$(NC)          - Show this help message"
	@echo "  $(GREEN)make clean$(NC)         - Remove build artifacts and cache"
	@echo "  $(GREEN)make build$(NC)         - Build the project (debug)"
	@echo "  $(GREEN)make build-release$(NC) - Build the project (release optimized)"
	@echo "  $(GREEN)make test$(NC)          - Run all unit tests"
	@echo "  $(GREEN)make test-verbose$(NC)  - Run tests with verbose output"
	@echo "  $(GREEN)make test-phase1$(NC)   - Run Phase 1 tests only"
	@echo "  $(GREEN)make test-phase2$(NC)   - Run Phase 2 tests only"
	@echo "  $(GREEN)make test-coverage$(NC) - Run tests with code coverage"
	@echo "  $(GREEN)make run$(NC)           - Build and open in Xcode"
	@echo "  $(GREEN)make simulator$(NC)     - Boot iOS Simulator and run app"
	@echo "  $(GREEN)make release$(NC)       - Create release build"
	@echo "  $(GREEN)make format$(NC)        - Format Swift code (if swiftformat installed)"
	@echo "  $(GREEN)make lint$(NC)          - Lint Swift code (if swiftlint installed)"
	@echo "  $(GREEN)make install-tools$(NC) - Install development tools"
	@echo ""
	@echo "$(BOLD)Quick start:$(NC)"
	@echo "  make build && make test"
	@echo ""

# ============================================================================
# CLEANING
# ============================================================================

clean:
	@echo "$(BLUE)🗑️  Cleaning build artifacts...$(NC)"
	@rm -rf .build
	@rm -rf .swiftpm
	@echo "$(GREEN)✅ Clean complete$(NC)"

clean-all: clean
	@echo "$(BLUE)🗑️  Removing Xcode workspace...$(NC)"
	@rm -rf *.xcworkspace
	@rm -rf *.xcodeproj
	@echo "$(GREEN)✅ Full clean complete$(NC)"

# ============================================================================
# BUILDING
# ============================================================================

build:
	@echo "$(BLUE)🔨 Building project (debug)...$(NC)"
	@swift build
	@echo "$(GREEN)✅ Build complete$(NC)"

build-release:
	@echo "$(BLUE)🔨 Building project (release)...$(NC)"
	@swift build -c release
	@echo "$(GREEN)✅ Release build complete$(NC)"

build-verbose:
	@echo "$(BLUE)🔨 Building project (verbose)...$(NC)"
	@swift build -v

# ============================================================================
# TESTING
# ============================================================================

test:
	@echo "$(BLUE)🧪 Running all tests...$(NC)"
	@swift test
	@echo "$(GREEN)✅ All tests passed$(NC)"

test-verbose:
	@echo "$(BLUE)🧪 Running all tests (verbose)...$(NC)"
	@swift test -v

test-phase1:
	@echo "$(BLUE)🧪 Running Phase 1 tests...$(NC)"
	@swift test --filter Phase1Tests

test-phase2:
	@echo "$(BLUE)🧪 Running Phase 2 tests...$(NC)"
	@swift test --filter Phase2Tests

test-coverage:
	@echo "$(BLUE)🧪 Running tests with code coverage...$(NC)"
	@swift test --enable-code-coverage
	@echo "$(YELLOW)ℹ️  Code coverage report available in .build/debug/codecov/$(NC)"

test-watch:
	@echo "$(BLUE)🧪 Watching for changes and running tests...$(NC)"
	@while true; do \
		clear; \
		swift test 2>&1 | tail -20; \
		echo "$(YELLOW)Waiting for changes...$(NC)"; \
		inotifywait -r -e modify Sources Tests 2>/dev/null || sleep 2; \
	done

# ============================================================================
# RUNNING
# ============================================================================

run: build
	@echo "$(BLUE)🚀 Opening project in Xcode...$(NC)"
	@open .

# Boot simulator and run app
simulator: clean build
	@echo "$(BLUE)📱 Starting iOS Simulator...$(NC)"
	@xcrun simctl boot "iPhone 15" 2>/dev/null || true
	@sleep 2
	@echo "$(BLUE)🚀 Opening project in Xcode...$(NC)"
	@open .
	@echo "$(YELLOW)ℹ️  In Xcode: Select 'iPhone 15' simulator and press Cmd+R to run$(NC)"

# ============================================================================
# RELEASING
# ============================================================================

release: clean build-release test
	@echo "$(GREEN)✅ Release build ready$(NC)"
	@echo "$(YELLOW)ℹ️  Next: Update version in Package.swift and git tag$(NC)"

# ============================================================================
# CODE QUALITY
# ============================================================================

format:
	@command -v swiftformat >/dev/null 2>&1 || { echo "$(YELLOW)swiftformat not installed. Run: brew install swiftformat$(NC)"; exit 1; }
	@echo "$(BLUE)📝 Formatting Swift code...$(NC)"
	@swiftformat Sources Tests
	@echo "$(GREEN)✅ Formatting complete$(NC)"

lint:
	@command -v swiftlint >/dev/null 2>&1 || { echo "$(YELLOW)swiftlint not installed. Run: brew install swiftlint$(NC)"; exit 1; }
	@echo "$(BLUE)🔍 Linting Swift code...$(NC)"
	@swiftlint lint Sources Tests
	@echo "$(GREEN)✅ Linting complete$(NC)"

# ============================================================================
# TOOLS
# ============================================================================

install-tools:
	@echo "$(BLUE)📦 Installing development tools...$(NC)"
	@command -v brew >/dev/null 2>&1 || { echo "$(YELLOW)Homebrew not found. Install from https://brew.sh$(NC)"; exit 1; }
	@echo "  Installing swiftformat..."
	@brew install swiftformat 2>/dev/null || brew upgrade swiftformat
	@echo "  Installing swiftlint..."
	@brew install swiftlint 2>/dev/null || brew upgrade swiftlint
	@echo "$(GREEN)✅ Tools installed$(NC)"

# ============================================================================
# INFO
# ============================================================================

info:
	@echo "$(BOLD)Project Information$(NC)"
	@echo ""
	@echo "Swift version:"
	@swift --version
	@echo ""
	@echo "Project structure:"
	@echo "  Sources/Core/          - Release 1.0 (Audio Player MVP)"
	@echo "  Sources/Reader/        - Release 2.0 (Reader MVP)"
	@echo "  Sources/App/           - iOS App entry point"
	@echo "  Tests/                 - Unit and integration tests"
	@echo ""
	@echo "Build artifacts: .build/"
	@echo "Package manifest: Package.swift"

# ============================================================================
# GIT OPERATIONS
# ============================================================================

git-status:
	@git --no-pager status

git-log:
	@git --no-pager log --oneline -10

git-branch:
	@git branch -a

# ============================================================================
# DEFAULT TARGET
# ============================================================================

.DEFAULT_GOAL := help
