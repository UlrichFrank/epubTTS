# epubTTS Implementation Plan - Release 1.0

Structured implementation phases for the epubTTS Audio Player MVP. Each phase is independently testable and verifiable.

---

## Phase Overview

| Phase | Focus | Duration | Testing | Status |
|-------|-------|----------|---------|--------|
| 1 | Project Setup & Dependencies | Initial | N/A | ✅ Complete |
| 2 | Services & Models | Core | Unit Tests | ✅ Complete |
| 3 | ViewModel & Integration | Logic | Integration Tests | ✅ Complete |
| 4 | UI & Comprehensive Testing | Interface | UI + Comprehensive Tests | ✅ Complete |

---

## Phase 1: Project Setup & Dependencies

### Goals
- Set up Xcode project with SwiftUI
- Configure CocoaPods for dependencies
- Establish project structure (MVVM)
- Initialize git repository

### Tasks

**1.1 Create Xcode Project**
```bash
# Create new iOS App project
# - App name: epubTTS
# - Interface: SwiftUI
# - Minimum deployment: iOS 15.0
# - Language: Swift
```

**1.2 Configure Project Structure**
```
epubTTS/
├── App/
│   └── epubTTSApp.swift
├── Views/
│   └── AudioPlayerView.swift
├── ViewModels/
│   └── AudioPlayerViewModel.swift
├── Models/
├── Services/
├── Utils/
└── Tests/
```

**1.3 Install CocoaPods Dependencies**
```bash
pod init
# Add to Podfile:
pod 'Readium', '~> 2.0'  # ePub parsing
pod 'Quick'              # Testing framework (optional)
pod 'Nimble'             # Matcher library (optional)
pod install
```

**1.4 Initialize Git Repository**
```bash
git init
git add .
git commit -m "Initial project setup"
```

### Verification
- ✅ Xcode project builds successfully
- ✅ Dependencies installed via CocoaPods
- ✅ Initial git commit created

---

## Phase 2: Services & Models

### Goals
- Implement core business logic services
- Define data models
- Create unit tests for services
- Achieve >90% service coverage

### Tasks

#### 2.1 Implement Models

**Task 2.1.1: Define AudioPlayerError**
- Custom error enum with all error cases
- LocalizedError compliance with descriptions
- Recovery suggestions for each error

**Requirement Tracing**: REQ-NF001-v1

**Task 2.1.2: Define AudioStatus**
- Enum: idle, loading, playing, paused, finished, error
- Hashable for use in conditional views

**Requirement Tracing**: REQ-F009-v1

**Task 2.1.3: Define EPubFile, EPubMetadata, EPubChapter**
- Immutable structs with Codable support
- Model equality and hashing
- Default values where appropriate

**Requirement Tracing**: REQ-F003-v1, REQ-F004-v1

#### 2.2 Implement FileService

**Task 2.2.1: File Import**
```swift
@MainActor
class FileService {
    func importEPubFile(from url: URL) async throws -> EPubFile
}
```
- Copy file to app sandbox
- Validate file format (check mimetype)
- Enforce 200MB size limit
- Return EPubFile with metadata

**Requirement Tracing**: REQ-F002-v1, REQ-NF002-v1, REQ-NF006-v1

**Testing**:
- ✅ Test valid ePub import
- ✅ Test invalid file rejection
- ✅ Test file not found handling
- ✅ Test size limit enforcement

#### 2.3 Implement EPubService

**Task 2.3.1: Parse ePub Structure**
```swift
@MainActor
class EPubService {
    func parseEPubFile(_ url: URL) async throws -> EPubFile
}
```
- Read container.xml to find package.opf
- Parse metadata from package.opf
- Extract chapters from spine
- Strip HTML and decode entities

**Requirement Tracing**: REQ-F003-v1, REQ-F004-v1, REQ-NF003-v1

**ePub Format Handling**:
- ✅ Support ePub 2.0 (OPF 2.0)
- ✅ Support ePub 3.0 (OPF 3.0)
- ✅ Extract title, author, language from metadata
- ✅ Parse spine for chapter order
- ✅ Handle HTML entity decoding

**Testing**:
- ✅ Test metadata extraction
- ✅ Test chapter parsing
- ✅ Test HTML stripping
- ✅ Test entity decoding

#### 2.4 Implement AudioService

**Task 2.4.1: TTS Synthesis & Playback**
```swift
@MainActor
class AudioService {
    func synthesizeAndPlay(text: String, rate: Float) async throws
    func pausePlayback()
    func stopPlayback()
    func setPlaybackRate(_ rate: Float)
}
```
- Configure AVAudioSession
- Use AVSpeechSynthesizer for TTS
- Use AVAudioPlayer for playback
- Support playback rate 0.5x - 2.0x
- Clamp rate to valid range

**Requirement Tracing**: REQ-F007-v1, REQ-F008-v1, REQ-NF004-v1

**Testing**:
- ✅ Test audio session configuration
- ✅ Test rate clamping
- ✅ Test playback state management
- ✅ Test stop without active playback

### Phase 2 Verification

**Unit Tests** (Phase 2 Tests):
```bash
xcodebuild test -scheme epubTTS -only-testing:epubTTSTests/Phase2Tests
```

**Expected Results**:
- ✅ 12+ unit tests passing
- ✅ Services coverage >90%
- ✅ Models coverage >90%
- ✅ No runtime errors

---

## Phase 3: ViewModel & Integration Testing

### Goals
- Implement AudioPlayerViewModel
- Orchestrate services
- Create integration tests
- Verify complete workflows

### Tasks

#### 3.1 Implement AudioPlayerViewModel

**Task 3.1.1: State Management**
```swift
@ObservableObject
class AudioPlayerViewModel: ObservableObject {
    @Published var epubFile: EPubFile?
    @Published var status: AudioStatus = .idle
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var playbackRate: Float = 1.0
    @Published var errorAlert: AudioPlayerError?
}
```

**Requirement Tracing**: REQ-F008-v1, REQ-F009-v1

**Task 3.1.2: Import Workflow**
```swift
func importEPubFile(from url: URL) async
```
- Call FileService to import
- Call EPubService to parse
- Update epubFile and status
- Handle errors with user-friendly messages

**Requirement Tracing**: REQ-F002-v1, REQ-F003-v1

**Task 3.1.3: Playback Control**
```swift
func play()
func pause()
func stop()
```
- Update status appropriately
- Coordinate with AudioService
- Update timeline during playback

**Requirement Tracing**: REQ-F008-v1

**Task 3.1.4: Chapter Navigation**
```swift
func jumpToChapter(_ index: Int)
```
- Validate chapter index
- Update selected chapter
- Reset playback to chapter start

**Requirement Tracing**: REQ-F004-v1

**Task 3.1.5: Playback Rate Control**
```swift
func updatePlaybackRate(_ rate: Float)
```
- Clamp rate to 0.5x - 2.0x
- Update AudioService
- Persist preference

**Requirement Tracing**: REQ-F008-v1

#### 3.2 Integration Tests

**Task 3.2.1: Create Phase 3 Integration Tests**
```bash
tests/Phase3IntegrationTests.swift
```

**Test Cases**:
- ✅ Full import & playback flow
- ✅ Play/pause toggle
- ✅ Chapter navigation
- ✅ Playback rate control
- ✅ Error handling & recovery
- ✅ UI state transitions
- ✅ Utility formatting (time, file size)

### Phase 3 Verification

**Integration Tests**:
```bash
xcodebuild test -scheme epubTTS -only-testing:epubTTSTests/Phase3IntegrationTests
```

**Expected Results**:
- ✅ 15+ integration tests passing
- ✅ Complete workflows verified
- ✅ State transitions correct
- ✅ No runtime errors

---

## Phase 4: UI & Comprehensive Testing

### Goals
- Implement AudioPlayerView
- Create comprehensive test suite
- Verify edge cases and performance
- Achieve >80% overall coverage

### Tasks

#### 4.1 Implement AudioPlayerView

**Task 4.1.1: View Structure**
```swift
struct AudioPlayerView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    
    var body: some View {
        // File information section
        // Status indicator
        // Playback controls
        // Progress tracking
        // Rate control
        // Chapter navigation
        // Error alerts
    }
}
```

**Sections**:
- **Empty State**: "No file loaded" message with import button
- **File Header**: Title, author, chapter count
- **Status Bar**: Current status with icon and time display
- **Playback Controls**: Play, Pause, Stop buttons
- **Progress**: Visual progress bar with current/total time
- **Rate Slider**: 0.5x to 2.0x with current value display
- **Chapters**: Navigation buttons for each chapter
- **Error Alerts**: User-friendly error dialogs with recovery

**Requirement Tracing**: REQ-F009-v1

**Task 4.1.2: Document Picker Integration**
```swift
func documentPickerViewController(
    _ controller: UIDocumentPickerViewController,
    didPickDocumentsAt urls: [URL]
)
```
- Handle file selection from document picker
- Call viewModel.importEPubFile()
- Update UI based on import result

**Requirement Tracing**: REQ-F002-v1

#### 4.2 Comprehensive Tests

**Task 4.2.1: Create Phase 4 Tests**
```bash
tests/Phase4ComprehensiveTests.swift
```

**Test Coverage**:
- ✅ Error descriptions & recovery suggestions
- ✅ Audio status properties
- ✅ Model structure validation
- ✅ Model equality and hashing
- ✅ Logger functionality
- ✅ Performance benchmarks
- ✅ Edge cases (invalid indices, empty chapters)
- ✅ Memory tests (1000+ chapters)
- ✅ Encoding/decoding validation

**Performance Benchmarks**:
```swift
func testFileImportPerformance() {
    // Measure: file import <2 seconds
}

func testEPubParsingPerformance() {
    // Measure: parsing <1 second
}

func testTTSPerformance() {
    // Measure: TTS <5 seconds per 1000 words
}

func testMemoryUsage() {
    // Verify: peak memory <200MB
}
```

**Memory Tests**:
```swift
func testLargeBookMemory() {
    // Create EPubFile with 1000+ chapters
    // Verify memory usage reasonable
}
```

### Phase 4 Verification

**Comprehensive Tests**:
```bash
xcodebuild test -scheme epubTTS -only-testing:epubTTSTests/Phase4ComprehensiveTests
```

**Code Coverage**:
```bash
xcodebuild test -scheme epubTTS -enableCodeCoverage YES
```

**Expected Results**:
- ✅ 35+ total tests passing
- ✅ Overall coverage >80%
- ✅ Services >90% coverage
- ✅ Models >90% coverage
- ✅ ViewModels >85% coverage
- ✅ Views >70% coverage
- ✅ All performance targets met
- ✅ No memory leaks

---

## Implementation Order (Dependency Chain)

1. **Models** → Needed by all layers
2. **Services** → Used by ViewModel
3. **ViewModel** → Coordinates services
4. **Views** → Uses ViewModel
5. **Tests** → Verify implementation

## Task Checklist

### Phase 1: Setup
- [ ] Create Xcode project
- [ ] Configure project structure
- [ ] Install CocoaPods
- [ ] Initialize git

### Phase 2: Services & Models
- [ ] Implement AudioPlayerError
- [ ] Implement AudioStatus
- [ ] Implement EPubFile, EPubMetadata, EPubChapter
- [ ] Implement FileService
- [ ] Implement EPubService
- [ ] Implement AudioService
- [ ] Write unit tests (12+ tests)
- [ ] Verify >90% service coverage

### Phase 3: ViewModel & Integration
- [ ] Implement AudioPlayerViewModel
- [ ] Implement import workflow
- [ ] Implement playback controls
- [ ] Implement chapter navigation
- [ ] Implement rate control
- [ ] Write integration tests (15+ tests)
- [ ] Verify complete workflows

### Phase 4: UI & Comprehensive
- [ ] Implement AudioPlayerView
- [ ] Integrate document picker
- [ ] Implement state transitions
- [ ] Write comprehensive tests (35+ total)
- [ ] Verify >80% overall coverage
- [ ] Performance validation
- [ ] Memory profiling
- [ ] Final release verification

---

**Last Updated**: 2026-02-27  
**Release**: 1.0 Audio Player MVP  
**Status**: Implementation Complete ✅  
**Test Coverage**: >80% Achieved ✅
