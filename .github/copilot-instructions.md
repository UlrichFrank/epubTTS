# Copilot Instructions for epubTTS

GitHub Copilot guide for working effectively on the epubTTS iOS audio player project.

## ⚠️ Critical Safety Rules

- **Destructive functions require human verification** - No automatic deletions or file overwrites
- **Documentation-first approach** - Requirements → Design → Implementation (mandatory order)
- **No sensitive data in code** - API keys and credentials go in `.env`

## Project Overview

**epubTTS** is an iOS app that enables users to listen to ePub books using text-to-speech synthesis. The project uses **MVVM architecture** with **SwiftUI** for the UI, **AVFoundation** for TTS and playback, and **Readium Swift Toolkit** for ePub parsing.

**Current Status**: Release 1.0 (Audio Player MVP) in progress. See [constitution.md](../constitution.md) for project values and principles.

## Build & Run Commands

### Installation & Setup
```bash
# Navigate to project root
cd /Users/ulrich.frank/Dev/private/epubTTS

# Install CocoaPods dependencies
pod install --repo-update

# Open the Xcode workspace (CRITICAL: use .xcworkspace, not .xcodeproj)
open epubTTS.xcworkspace
```

### Build & Run
```bash
# Build the app
xcodebuild build -scheme epubTTS

# Run the app on simulator
xcodebuild run -scheme epubTTS -destination 'generic/platform=iOS Simulator'

# Or in Xcode: Select target epubTTS, select iPhone 15 Pro simulator, Cmd+B to build, Cmd+R to run
```

### Testing Commands
```bash
# Run all tests
xcodebuild test -scheme epubTTS -configuration Debug

# Run a specific test file
xcodebuild test -scheme epubTTS -only-testing:epubTTSTests/Phase2Tests

# Run tests with code coverage
xcodebuild test -scheme epubTTS -enableCodeCoverage YES

# Run a single test method
xcodebuild test -scheme epubTTS -only-testing:epubTTSTests/Phase2Tests/FileServiceTests/testImportValidEPubFile
```

### Code Coverage
```bash
xcodebuild test -scheme epubTTS -enableCodeCoverage YES -resultBundlePath coverage.xcresult
open coverage.xcresult
```

## Architecture Overview

### MVVM + Service Layer Pattern

The app follows a clean separation of concerns:

```
Views (SwiftUI)
  ↓ Observable
ViewModels (@ObservableObject)
  ↓ Owns
Services (@MainActor)
  ↓ Manages
Models (Structs with Codable)
```

### Key Components

**Services** (handle business logic, marked with `@MainActor`):
- **FileService**: ePub file import, validation, sandboxing
- **EPubService**: Parse ePub metadata, chapters, extract text
- **AudioService**: TTS synthesis (AVSpeechSynthesizer), playback (AVAudioPlayer), rate control

**ViewModels** (@ObservableObject):
- **AudioPlayerViewModel**: Orchestrates file import, playback, error handling, state management

**Views** (SwiftUI):
- **AudioPlayerView**: Main UI with file info, playback controls, progress tracking, error alerts

**Models** (Immutable Structs):
- **EPubFile**: Complete ePub document (metadata + chapters)
- **EPubMetadata**: Title, author, language, chapter count
- **EPubChapter**: Chapter number, title, text content
- **AudioStatus**: Enum (idle, loading, playing, paused, finished, error)
- **AudioPlayerError**: Comprehensive error types with recovery suggestions

### Directory Structure
```
epubTTS/
├── App/
│   └── epubTTSApp.swift              # App entry point
├── Views/
│   └── AudioPlayerView.swift         # Main SwiftUI interface
├── ViewModels/
│   └── AudioPlayerViewModel.swift    # State management & lifecycle
├── Models/
│   ├── EPubFile.swift                # Document model
│   ├── EPubMetadata.swift            # Metadata model
│   ├── EPubChapter.swift             # Chapter model
│   ├── AudioStatus.swift             # Playback status enum
│   └── AudioPlayerError.swift        # Error definitions
├── Services/
│   ├── FileService.swift             # File import & management
│   ├── EPubService.swift             # ePub parsing
│   ├── AudioService.swift            # TTS & playback
│   └── Logger.swift                  # Logging utility
└── Utils/
    └── ...
```

## Key Conventions

### 1. Async/Await Pattern
Services use async/await, not completion handlers:
```swift
@MainActor
class FileService {
    func importEPubFile(from url: URL) async throws -> EPubFile {
        // Perform work on MainActor
    }
}
```

### 2. Error Handling
Use the custom `AudioPlayerError` enum with associated values:
```swift
enum AudioPlayerError: LocalizedError {
    case invalidFile(reason: String)
    case fileNotFound(path: String)
    case fileAccessDenied(path: String)
    case insufficientMemory(required: Int, available: Int)
    case failedToSynthesizeAudio(reason: String)
    case audioPlaybackFailed(reason: String)
}
```
Always provide meaningful `errorDescription` and `recoverySuggestion`.

### 3. State Management
Use `@Published` properties in ViewModels and `@Observable` for SwiftUI binding:
```swift
@ObservableObject
class AudioPlayerViewModel: ObservableObject {
    @Published var epubFile: EPubFile?
    @Published var status: AudioStatus = .idle
    @Published var errorAlert: AudioPlayerError?
}
```

### 4. Testing Strategy
- **Unit Tests** (`Phase2Tests.swift`): Service initialization, validation logic
- **Integration Tests** (`Phase3IntegrationTests.swift`): Full workflows (import → parse → playback)
- **Comprehensive Tests** (`Phase4ComprehensiveTests.swift`): Edge cases, performance, memory

Run tests frequently during development.

### 5. Commit Format
Include requirement IDs in commit messages:
```
feat(component): description (REQ-ID)

- Detailed change 1
- Detailed change 2
- Requirements satisfied

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

Example:
```
feat(AudioService): implement playback rate control (REQ-F008-v1)

- Add playbackRate property with 0.5x to 2.0x range
- Clamp values to valid range
- Update AVSpeechSynthesizer rate on change
- Add unit tests for rate clamping

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

### 6. Memory Limits
ePub files are limited to 200MB (enforced in FileService):
```swift
let MAX_FILE_SIZE = 200 * 1024 * 1024  // 200MB
```

### 7. Deployment Target
- **iOS**: 15.0+
- **Swift**: 5.9+
- **Xcode**: 15.0+

## Documentation References

| Document | Purpose |
|----------|---------|
| [README.md](../README.md) | Overview, features, quick start |
| [TESTING.md](../TESTING.md) | Manual test cases & automated test guide |
| [constitution.md](../constitution.md) | Project values & coding standards |

## Before Committing

1. **Run tests**: `xcodebuild test -scheme epubTTS`
2. **Check coverage**: Target >80% overall (Services >90%, Models >90%)
3. **Verify requirements**: Commit message includes REQ-ID
4. **Update docs**: If behavior changes, update README.md or TESTING.md
5. **Code review**: Follow MVVM pattern, use @MainActor for services

## Common Tasks

### Adding a New Service
1. Create struct conforming to service pattern
2. Mark class with `@MainActor`
3. Use async/await for long operations
4. Add comprehensive error handling
5. Write unit tests for validation and edge cases
6. Write integration test for complete workflow

### Adding a New Model
1. Use struct (value type, Codable)
2. Add comprehensive error handling in initializers
3. Implement Equatable for testing
4. Add model unit tests

### Modifying ViewModel
1. Add @Published properties for observable state
2. Ensure async operations dispatch to MainActor
3. Handle errors and update errorAlert
4. Update corresponding tests

### UI Changes
1. Modify AudioPlayerView.swift
2. Update state management in AudioPlayerViewModel
3. Test on multiple device sizes (iPhone SE, 15 Pro, iPad)
4. Verify accessibility (VoiceOver, Dynamic Type)

## Performance Targets

| Requirement | Target | Status |
|-----------|--------|--------|
| File import | <2s | Monitored |
| ePub parsing | <1s | Monitored |
| TTS synthesis | <5s per 1000 words | Monitored |
| Memory usage | <200MB | Enforced |

## Troubleshooting

### Build Fails: "Cannot find module 'epubTTS'"
Use the **workspace** file, not the project file:
```bash
open epubTTS.xcworkspace  # ✅ Correct
# NOT: open epubTTS.xcodeproj
```

### Build Fails: Pod dependencies not found
```bash
pod install --repo-update
rm -rf ~/Library/Developer/Xcode/DerivedData/
```

### Tests Fail: Module not found
```bash
# Close Xcode, clear build cache, reopen
killall Xcode
rm -rf ~/Library/Developer/Xcode/DerivedData/
open epubTTS.xcworkspace
```

### Runtime: App crashes on ePub import
- Verify ePub file is valid format (check TESTING.md)
- File size must be <200MB
- Check device storage space

### Runtime: Audio not playing
- In simulator: Verify audio is enabled (simulator preferences)
- Check AVAudioSession is configured correctly
- Verify ePub file was parsed successfully

## Release Workflow

All releases use **MVP (Minimum Viable Product)** approach:

1. **Release 1.0** (CURRENT): Audio Player MVP
   - ePub import, TTS, playback controls, chapter navigation
   
2. **Release 2.0** (Planned): Reader MVP
   - On-screen text display, text-audio sync, bookmarks
   
3. **Release 3.0** (Planned): Smart Reader MVP
   - Dark mode, preferences, accessibility

See [README.md](../README.md) for full feature roadmap.

## Project Principles & Values

### Coding Standards
- **Clean Code**: Follow industry best practices
- **SOLID Principles**: Single responsibility, dependency injection
- **Test-Driven Development (TDD)**: Tests guide implementation
- **MVP Strategy**: Multiple standalone products that together form a complete app

### MVP Release Strategy

Create **multiple app releases as Minimum Viable Products**:
- Each MVP is fully functional and provides value to users **on its own**
- Each MVP together with others builds toward complete product
- Allows iterative development with tangible interim products
- Example: Release 1.0 (Audio Player) → Release 2.0 (Reader) → Release 3.0 (Smart Reader)

### Security & Safety Rules
- ✅ **No API keys in code** - Use `.env` for sensitive data
- ✅ **Destructive functions must be verified by human** - No automatic deletions
- ✅ **Documentation-first approach** - Requirements → Design → Implementation

### Development Workflow (Mandatory Order)

Before implementing ANY feature:
1. **Requirements Document** - Individually traceable requirements
2. **Design Document** - Traceability to requirements  
3. **Implementation Plan** - Sequential, checkable steps
4. **Documentation** - All changes documented and verifiable
5. **Consistency Check** - All documents aligned with codebase

## Additional Resources

- AVFoundation documentation: Apple's framework for audio and TTS
- SwiftUI documentation: Modern Swift UI framework
- Readium Swift Toolkit: ePub parsing and processing
- ePub Standard: IDPF specification for ePub 2.0 and 3.0

---

**Last Updated**: 2026-02-27  
**Project Status**: Release 1.0 Audio Player MVP  
**Architecture Pattern**: MVVM + Service Layer  
**Testing Framework**: XCTest with Quick/Nimble support  
**Documentation-First**: Requirements → Design → Implementation
