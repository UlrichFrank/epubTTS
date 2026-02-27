# Swift Implementation Recovery Plan

Based on DESIGN.md and IMPLEMENTATION.md, here are the Swift files that need to be recreated.

## File Structure

```
epubTTS/
├── App/
│   └── epubTTSApp.swift              # SwiftUI app entry point
├── Views/
│   └── AudioPlayerView.swift         # Main UI (3+ subviews)
├── ViewModels/
│   └── AudioPlayerViewModel.swift    # State management
├── Models/
│   ├── EPubFile.swift                # Codable struct
│   ├── EPubMetadata.swift            # Codable struct
│   ├── EPubChapter.swift             # Codable struct
│   ├── AudioStatus.swift             # Enum (Hashable)
│   └── AudioPlayerError.swift        # Error enum (LocalizedError)
├── Services/
│   ├── FileService.swift             # @MainActor, file import
│   ├── EPubService.swift             # @MainActor, ePub parsing
│   ├── AudioService.swift            # @MainActor, TTS + playback
│   └── Logger.swift                  # Utility logging
└── Utils/
    └── ...

Tests/
├── Phase2Tests.swift                 # Unit tests (12+ tests)
├── Phase3IntegrationTests.swift      # Integration tests (15+ tests)
└── Phase4ComprehensiveTests.swift    # Comprehensive tests (35+ total)
```

## Models (Priority: HIGH)

### EPubFile.swift
```swift
struct EPubFile: Identifiable, Codable {
    let id: UUID
    let metadata: EPubMetadata
    let chapters: [EPubChapter]
    let fileURL: URL?
}
```

**Requirements**: REQ-F003-v1, REQ-F004-v1

### EPubMetadata.swift
```swift
struct EPubMetadata: Codable {
    let title: String
    let author: String?
    let language: String?
    let chapterCount: Int
}
```

**Requirements**: REQ-F003-v1

### EPubChapter.swift
```swift
struct EPubChapter: Identifiable, Codable {
    let id: UUID
    let number: Int
    let title: String
    let text: String
}
```

**Requirements**: REQ-F004-v1

### AudioStatus.swift
```swift
enum AudioStatus: Hashable {
    case idle
    case loading
    case playing
    case paused
    case finished
    case error(AudioPlayerError)
}
```

**Requirements**: REQ-F009-v1

### AudioPlayerError.swift
```swift
enum AudioPlayerError: LocalizedError {
    case invalidFile(reason: String)
    case fileNotFound(path: String)
    case fileAccessDenied(path: String)
    case insufficientMemory(required: Int, available: Int)
    case failedToSynthesizeAudio(reason: String)
    case audioPlaybackFailed(reason: String)
    
    var errorDescription: String?
    var recoverySuggestion: String?
}
```

**Requirements**: REQ-NF001-v1

## Services (Priority: HIGH)

### FileService.swift
**Lines**: ~150-200  
**Key Methods**:
- `importEPubFile(from url: URL) async throws -> EPubFile`
- Size validation (<200MB)
- Sandbox file management

**Requirements**: REQ-F002-v1, REQ-NF002-v1, REQ-NF006-v1

**Tests**:
- testImportValidEPubFile
- testInvalidFileRejection
- testFileNotFoundHandling
- testSizeLimitEnforcement

### EPubService.swift
**Lines**: ~200-300  
**Key Methods**:
- `parseEPubFile(_ url: URL) async throws -> EPubFile`
- Container.xml parsing to find OPF
- Package.opf metadata extraction
- Spine parsing for chapter order
- HTML stripping and entity decoding

**Requirements**: REQ-F003-v1, REQ-F004-v1, REQ-NF003-v1

**Tests**:
- testMetadataExtraction
- testChapterParsing
- testHTMLStripping
- testEntityDecoding

### AudioService.swift
**Lines**: ~200-250  
**Key Methods**:
- `synthesizeAndPlay(text: String, rate: Float) async throws`
- `pausePlayback()`
- `stopPlayback()`
- `setPlaybackRate(_ rate: Float)`
- AVAudioSession configuration
- AVSpeechSynthesizer setup
- AVAudioPlayer playback control

**Requirements**: REQ-F007-v1, REQ-F008-v1, REQ-NF004-v1

**Tests**:
- testAudioSessionConfiguration
- testPlaybackRateClamping
- testPlaybackStateManagement
- testStopWithoutActivePlayback

### Logger.swift
**Lines**: ~50-100  
**Key Methods**:
- `log(_ message: String, level: LogLevel)`
- Support for debug/info/warning/error levels

---

## ViewModel (Priority: HIGH)

### AudioPlayerViewModel.swift
**Lines**: ~400-500  

**@Published Properties**:
```swift
@Published var epubFile: EPubFile?
@Published var status: AudioStatus = .idle
@Published var currentTime: TimeInterval = 0
@Published var duration: TimeInterval = 0
@Published var playbackRate: Float = 1.0
@Published var errorAlert: AudioPlayerError?
@Published var selectedChapter: Int = 0
@Published var isLoading: Bool = false
```

**Key Methods**:
- `importEPubFile(from url: URL) async`
- `play()`
- `pause()`
- `stop()`
- `jumpToChapter(_ index: Int)`
- `updatePlaybackRate(_ rate: Float)`
- Utility methods (formatTime, fileSize, etc.)

**Requirements**: REQ-F008-v1, REQ-F009-v1

---

## Views (Priority: MEDIUM)

### AudioPlayerView.swift
**Lines**: ~600-800  

**Sections**:
1. Empty state ("No file loaded")
2. File information header
3. Status indicator
4. Playback controls (Play, Pause, Stop)
5. Progress bar + time display
6. Playback rate slider (0.5x - 2.0x)
7. Chapter navigation buttons
8. Error alerts

**Key Features**:
- DocumentPickerViewController integration
- State-based conditional rendering
- Accessibility support (VoiceOver, Dynamic Type)
- Responsive layout for different screen sizes

**Requirements**: REQ-F009-v1, REQ-F002-v1

---

## App Entry Point (Priority: MEDIUM)

### epubTTSApp.swift
**Lines**: ~30-50  

```swift
@main
struct epubTTSApp: App {
    @StateObject var viewModel = AudioPlayerViewModel()
    
    var body: some Scene {
        WindowGroup {
            AudioPlayerView(viewModel: viewModel)
        }
    }
}
```

---

## Tests (Priority: HIGH)

### Phase2Tests.swift (Unit Tests)
**Target**: 12+ tests, >90% service coverage

**Test Classes**:
- FileServiceTests (3 tests)
- EPubServiceTests (2 tests)
- AudioServiceTests (3 tests)
- Error/Status tests (3 tests)

### Phase3IntegrationTests.swift (Integration Tests)
**Target**: 15+ tests, complete workflows

**Test Cases**:
- Full import & playback flow
- Play/pause toggle
- Chapter navigation
- Playback rate control
- Error handling & recovery
- UI state transitions
- Utility formatting

### Phase4ComprehensiveTests.swift (Comprehensive Tests)
**Target**: 35+ total, >80% coverage, edge cases

**Test Categories**:
- Error descriptions & recovery
- Audio status properties
- Model structure validation
- Model equality
- Logger functionality
- Performance benchmarks
- Edge cases (invalid indices, extremes)
- Memory tests (1000+ chapters)
- Encoding/decoding validation

---

## Implementation Order

1. **Models** (5 files) - No dependencies
2. **Services** (3 files) - Depend on models
3. **ViewModel** (1 file) - Depends on models + services
4. **Views** (1 file) - Depends on ViewModel
5. **App Entry** (1 file) - Depends on ViewModel
6. **Tests** (3 files) - Depend on all above

---

## Estimated Metrics

| Component | Files | Lines | Tests |
|-----------|-------|-------|-------|
| Models | 5 | 200 | 6 |
| Services | 3 | 650 | 12+ |
| ViewModel | 1 | 450 | 15+ |
| Views | 1 | 700 | 10+ |
| Utils | 1 | 50 | 2 |
| **Total** | **11** | **~2,050** | **35+** |

---

## Phase Breakdown

### Phase 2: Services & Models (5-7 days)
- [ ] Implement 5 model files
- [ ] Implement 3 service files
- [ ] Write 12+ unit tests
- [ ] Achieve >90% service coverage

### Phase 3: ViewModel & Integration (3-5 days)
- [ ] Implement AudioPlayerViewModel
- [ ] Write 15+ integration tests
- [ ] Verify complete workflows

### Phase 4: Views & Comprehensive (5-7 days)
- [ ] Implement AudioPlayerView
- [ ] Implement epubTTSApp
- [ ] Write 35+ comprehensive tests
- [ ] Achieve >80% overall coverage
- [ ] Performance validation

---

## Recovery Strategy

If Swift files need to be recovered from this document:

1. **Start with Phase 2**: Models first (no dependencies)
2. **Follow IMPLEMENTATION.md** for detailed task breakdown
3. **Reference DESIGN.md** for component specifications
4. **Use REQUIREMENTS.md** for acceptance criteria
5. **Follow test plan** from TESTING.md
6. **Verify each phase** before moving to next

---

**Status**: Recovery Documentation Complete ✅  
**Next**: Implement Phase 2 (Models & Services)  
**Estimated Total Time**: 12-20 days for complete implementation
