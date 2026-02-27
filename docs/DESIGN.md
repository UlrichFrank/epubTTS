# epubTTS Design Document - Release 1.0

Architecture and design decisions for the epubTTS Audio Player MVP.

## Design Goals

1. **Separation of Concerns**: MVVM + Service Layer for clean architecture
2. **Performance**: Meet all non-functional requirements (<2s import, <1s parsing, <5s TTS per 1000 words)
3. **Reliability**: Comprehensive error handling with user-friendly messages
4. **Testability**: 80%+ code coverage with unit and integration tests
5. **User Experience**: Intuitive SwiftUI interface with responsive controls

---

## Architecture Overview

### MVVM + Service Layer Pattern

```
┌─────────────────────────────────────────┐
│          SwiftUI Views                  │
│   (AudioPlayerView, subviews)          │
│   - Observes @Published properties     │
│   - Handles user interactions          │
└──────────────────┬──────────────────────┘
                   │ Observable (Combine)
┌──────────────────▼──────────────────────┐
│    ViewModels (@ObservableObject)      │
│  (AudioPlayerViewModel)                │
│  - State management                    │
│  - Coordinates services                │
│  - Handles lifecycle events            │
└──────────────────┬──────────────────────┘
                   │ Owns/Delegates to
┌──────────────────▼──────────────────────┐
│   Services (@MainActor)                │
│  - FileService                         │
│  - EPubService                         │
│  - AudioService                        │
│  - Business logic                      │
│  - Long-running operations             │
└──────────────────┬──────────────────────┘
                   │ Uses/Creates
┌──────────────────▼──────────────────────┐
│      Models (Immutable Structs)        │
│  - EPubFile, EPubMetadata              │
│  - EPubChapter, AudioStatus            │
│  - AudioPlayerError                    │
│  - Data structures                     │
└─────────────────────────────────────────┘
```

### Design Rationale

- **Views**: SwiftUI for modern, declarative UI; Combine for reactive updates
- **ViewModels**: @ObservableObject for state management and lifecycle coordination
- **Services**: @MainActor for thread safety; async/await for async operations
- **Models**: Immutable structs for thread safety and predictability

---

## Component Design

### 1. FileService

**Responsibility**: Import, validate, and manage ePub files

**Key Operations**:
```swift
func importEPubFile(from url: URL) async throws -> EPubFile
```

**Design Decisions**:
- Validates file format (check for mimetype and required XML files)
- Enforces 200MB size limit for memory protection
- Copies file to app sandbox for persistence
- Returns complete EPubFile with metadata and chapters

**Error Handling**:
- `AudioPlayerError.invalidFile(reason:)` for format errors
- `AudioPlayerError.fileAccessDenied(path:)` for permission issues
- `AudioPlayerError.insufficientMemory(...)` for size limit exceeded

---

### 2. EPubService

**Responsibility**: Parse ePub structure and extract content

**Key Operations**:
```swift
func parseEPubFile(_ url: URL) async throws -> EPubFile
func extractMetadata(_ url: URL) async throws -> EPubMetadata
func extractChapters(_ url: URL) async throws -> [EPubChapter]
```

**Design Decisions**:
- Extracts metadata from `content.opf` (title, author, language)
- Parses spine to determine chapter order
- Strips HTML tags and decodes XML entities
- Returns structured EPubFile with all chapters

**ePub Format Handling**:
- Supports ePub 2.0 (OPF 2.0) and ePub 3.0
- Reads `META-INF/container.xml` to locate package document
- Parses NCX table of contents for chapter structure
- Extracts chapter text from XHTML content documents

---

### 3. AudioService

**Responsibility**: TTS synthesis and playback control

**Key Operations**:
```swift
func synthesizeAndPlay(text: String, rate: Float) async throws
func pausePlayback()
func stopPlayback()
func setPlaybackRate(_ rate: Float)
```

**Design Decisions**:
- Uses AVSpeechSynthesizer for TTS (natural-sounding voices)
- Uses AVAudioPlayer for playback control (rate adjustment)
- Configures AVAudioSession for playback category
- Manages audio file lifecycle (create, play, cleanup)

**Playback Rate**:
- Range: 0.5x (slow) to 2.0x (fast)
- Default: 1.0x (normal)
- Clamped to valid range to prevent invalid values

**Audio Session**:
- Category: `.playback` (plays audio even when silent mode on)
- Options: `.defaultToSpeaker` (play through speaker)
- Mixable: No (takes control of audio output)

---

### 4. AudioPlayerViewModel

**Responsibility**: Orchestrate services and manage app state

**Key @Published Properties**:
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

**Design Decisions**:
- Coordinates FileService, EPubService, AudioService
- Manages state transitions (idle → loading → playing → paused)
- Provides convenience methods for UI (formatted time, file size)
- Centralizes error handling with user-friendly messages

**Lifecycle Methods**:
```swift
func importEPubFile(from url: URL) async
func play()
func pause()
func stop()
func jumpToChapter(_ index: Int)
func updatePlaybackRate(_ rate: Float)
```

---

### 5. AudioPlayerView

**Responsibility**: Present UI and handle user interactions

**Structure**:
- **Header**: File information (title, author, chapter count)
- **Player Section**: Status indicator, current time, duration
- **Controls**: Play/Pause, Stop buttons
- **Progress**: Visual progress bar
- **Rate Slider**: Playback speed control (0.5x - 2.0x)
- **Chapters**: Chapter navigation buttons (if multi-chapter)
- **Empty State**: "No file loaded" message
- **Error Alerts**: User-friendly error dialogs

**Design Decisions**:
- SwiftUI for declarative layout
- Uses @ObservedObject to subscribe to ViewModel updates
- Handles state transitions with conditional views
- Displays loading spinner during import
- Shows error alerts with recovery suggestions

---

### 6. Models

#### EPubFile
```swift
struct EPubFile: Identifiable, Codable {
    let id: UUID
    let metadata: EPubMetadata
    let chapters: [EPubChapter]
    let fileURL: URL?
}
```

#### EPubMetadata
```swift
struct EPubMetadata: Codable {
    let title: String
    let author: String?
    let language: String?
    let chapterCount: Int
}
```

#### EPubChapter
```swift
struct EPubChapter: Identifiable, Codable {
    let id: UUID
    let number: Int
    let title: String
    let text: String
}
```

#### AudioStatus
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

#### AudioPlayerError
```swift
enum AudioPlayerError: LocalizedError {
    case invalidFile(reason: String)
    case fileNotFound(path: String)
    case fileAccessDenied(path: String)
    case insufficientMemory(required: Int, available: Int)
    case failedToSynthesizeAudio(reason: String)
    case audioPlaybackFailed(reason: String)
    
    var errorDescription: String? { ... }
    var recoverySuggestion: String? { ... }
}
```

---

## Data Flow

### Import Workflow
```
User taps "Import ePub"
    ↓
DocumentPickerViewController shows
    ↓
User selects file
    ↓
ViewModel.importEPubFile(from:) called
    ↓
FileService.importEPubFile() validates & copies
    ↓
EPubService.parseEPubFile() extracts metadata & chapters
    ↓
ViewModel updates @Published epubFile
    ↓
View re-renders with file information
```

### Playback Workflow
```
User taps Play
    ↓
ViewModel.play() called
    ↓
AudioService.synthesizeAndPlay() generates audio
    ↓
ViewModel updates @Published status
    ↓
View shows status indicator & timeline
    ↓
Audio plays through speaker
```

---

## Thread Safety

### @MainActor Usage
- All Services marked with `@MainActor` to ensure UI updates on main thread
- AVSpeechSynthesizer and AVAudioPlayer require main thread
- State updates (@Published) automatically dispatch to main thread

### Immutable Models
- All model structs are immutable (no mutable properties)
- Thread-safe by design
- Support struct equality and hashing for UI updates

---

## Memory Management

### File Size Limits
- Maximum file size: 200MB (enforced in FileService)
- Protects against memory exhaustion

### Large Books
- Tested with 1000+ chapter books
- All chapters loaded into memory (pre-parsed)
- Reasonable for current ePub format constraints

### Audio Cleanup
- Audio files cleaned up after playback
- AVAudioPlayer released when no longer needed
- No memory leaks in long playback sessions

---

## Error Handling Strategy

### Error Propagation
```swift
do {
    let file = try await fileService.importEPubFile(from: url)
    self.epubFile = file
} catch let error as AudioPlayerError {
    self.errorAlert = error  // Show user-friendly message
} catch {
    self.errorAlert = .failedToSynthesizeAudio(reason: error.localizedDescription)
}
```

### User-Friendly Messages
Every error type includes:
- **errorDescription**: What went wrong (user-friendly)
- **recoverySuggestion**: How to fix it

Example:
- Error: "Unsupported file format"
- Suggestion: "Please select a valid ePub file (.epub)"

---

## Testing Strategy

### Unit Tests (Phase 2)
- Service initialization and validation
- Error handling paths
- Model creation and equality

### Integration Tests (Phase 3)
- Complete import workflow
- Playback control flows
- Chapter navigation
- UI state transitions

### Comprehensive Tests (Phase 4)
- Edge cases (invalid indices, empty chapters)
- Performance benchmarks
- Memory profiling
- Encoding/decoding validation

---

## Performance Targets & Design

| Operation | Target | Design | Notes |
|-----------|--------|--------|-------|
| File Import | <2s | Direct file copy + async parsing | Depends on device I/O |
| ePub Parsing | <1s | Cached metadata, lazy chapter loading | Pre-parsed at import |
| TTS Synthesis | <5s/1000 words | Use system AVSpeechSynthesizer | Native performance |
| Playback Latency | <200ms | Direct AVAudioPlayer control | System limit |
| Memory | <200MB | Size limit enforcement | Tested with 100+ chapters |

---

## Future Design Considerations (Release 2.0+)

### Text Display & Sync
- Render HTML content using SwiftUI's `Text` or custom renderer
- Use text ranges to sync highlighting with TTS utterance callbacks
- Implement progressive text streaming for large chapters

### Persistence
- Use Core Data or Codable for bookmarks and progress
- iCloud KV sync for cloud backup
- Local file storage in app documents directory

### UI Enhancements
- Split view for iPad (text + controls)
- Dark mode support with color scheme awareness
- Landscape orientation support

---

**Last Updated**: 2026-02-27  
**Release**: 1.0 Audio Player MVP  
**Status**: Production Ready ✅  
**Architecture Pattern**: MVVM + Service Layer
