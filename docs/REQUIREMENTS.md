# epubTTS Requirements Documentation

Complete requirements for the epubTTS iOS audio player project, organized by release.

## Release 1.0: Audio Player MVP (CURRENT - COMPLETE)

### Functional Requirements

| ID | Requirement | Description | Priority | Status |
|---|---|---|---|---|
| REQ-F002-v1 | ePub File Import | Load ePub files via document picker or file sharing | MUST HAVE | ✅ Complete |
| REQ-F003-v1 | File Validation & Parsing | Validate ePub format and parse structure (metadata, chapters) | MUST HAVE | ✅ Complete |
| REQ-F004-v1 | Chapter Extraction | Extract individual chapters from ePub spine and content documents | MUST HAVE | ✅ Complete |
| REQ-F007-v1 | Text-to-Speech Synthesis | Generate audio from ePub text using AVSpeechSynthesizer | MUST HAVE | ✅ Complete |
| REQ-F008-v1 | Playback Control | Play, pause, and stop audio with timeline tracking | MUST HAVE | ✅ Complete |
| REQ-F009-v1 | Playback Status Display | Show current status (idle, loading, playing, paused, finished, error) with visual indicators | MUST HAVE | ✅ Complete |

**Additional Features**:
- Playback rate adjustment (0.5x to 2.0x)
- Chapter navigation (for multi-chapter books)
- Progress tracking with visual progress bar and time display
- Comprehensive error handling with user-friendly messages
- Clean SwiftUI interface with status indicators

### Non-Functional Requirements

| ID | Requirement | Target | Measurement | Status |
|---|---|---|---|---|
| REQ-NF001-v1 | Error Handling | Comprehensive | All error paths covered with user-friendly messages | ✅ Complete |
| REQ-NF002-v1 | File Import Performance | <2 seconds | Time from selection to import completion | ✅ Met |
| REQ-NF003-v1 | ePub Parsing Performance | <1 second | Time to parse metadata and chapter list | ✅ Met |
| REQ-NF004-v1 | TTS Performance | <5 seconds per 1000 words | Audio synthesis time | ✅ Met |
| REQ-NF005-v1 | Playback Latency | <200ms | Button tap to audio output | ✅ Met |
| REQ-NF006-v1 | Memory Usage | <200MB | Peak memory during operation | ✅ Enforced |
| REQ-NF007-v1 | Code Coverage | >80% overall | Unit and integration tests | ✅ Achieved |
| REQ-NF008-v1 | Device Compatibility | iOS 15.0+ | Swift 5.9+, Xcode 15.0+ | ✅ Verified |

### Scope (Release 1.0)

**In Scope**:
- ePub 2.0 and 3.0 format support
- Document picker file selection
- TTS audio synthesis
- Playback controls
- Single app window interface
- Error handling

**Out of Scope** (for Release 2.0+):
- On-screen text display
- Text-to-audio synchronization
- Bookmarks and highlights
- Dark mode
- User preferences
- iCloud synchronization
- Multi-book library

---

## Release 2.0: Reader MVP (PLANNED)

### Features

- **Display ePub Text**: Render text content on screen
- **Text-Audio Sync**: Highlight currently spoken text
- **Bookmarks**: Save and resume from bookmarked positions
- **Highlights**: User-selectable text highlights
- **Auto-Scroll**: Text scrolls with audio playback

### Key Requirements

| ID | Requirement |
|---|---|
| REQ-F010-v2 | Render ePub text on screen using SwiftUI |
| REQ-F011-v2 | Parse and apply CSS styling from ePub |
| REQ-F012-v2 | Synchronize text highlight with TTS playback |
| REQ-F013-v2 | Implement bookmarking system (persist to device) |
| REQ-F014-v2 | Text selection and highlighting |
| REQ-F015-v2 | Auto-scroll during playback |

---

## Release 3.0: Smart Reader MVP (PLANNED)

### Features

- **Dark Mode**: Support dark theme
- **User Preferences**: Voice selection, reading speed presets
- **Accessibility**: VoiceOver support, Dynamic Type
- **Advanced Search**: Full-text search within book

### Key Requirements

| ID | Requirement |
|---|---|
| REQ-F016-v3 | Dark mode theme support |
| REQ-F017-v3 | User voice preference selection |
| REQ-F018-v3 | Reading speed presets (slow/normal/fast) |
| REQ-F019-v3 | VoiceOver and accessibility features |
| REQ-F020-v3 | Full-text search within books |

---

## Release 4.0+: Pro Reader (PLANNED)

### Features

- **Multi-Book Library**: Manage multiple ePub files
- **iCloud Sync**: Synchronize progress across devices
- **Notes Management**: Add and organize notes
- **Cloud Backup**: Backup library to cloud storage

---

## Technical Constraints

### Device Requirements

- **Minimum iOS Version**: iOS 15.0
- **Swift Version**: 5.9+
- **Xcode Version**: 15.0+
- **macOS**: Current or previous major version

### Performance Constraints

- File size limit: <200MB (enforced by FileService)
- TTS synthesis: <5 seconds per 1000 words
- Memory: <200MB peak during normal operation

### API & Framework Requirements

- **AVFoundation**: AVSpeechSynthesizer (TTS), AVAudioPlayer (playback)
- **SwiftUI**: Modern iOS UI framework
- **Readium Swift Toolkit**: ePub parsing and processing
- **DocumentPickerViewController**: File selection
- **URLSession**: Network operations (if needed)

### ePub Standard Compliance

- **ePub 2.0**: IDPF specification
- **ePub 3.0**: IDPF specification
- **Metadata**: Extract title, author, language
- **Content**: HTML/XML parsing with entity decoding

---

## Acceptance Criteria (Release 1.0)

### File Import
- ✅ Document picker opens when user taps "Import ePub"
- ✅ Selected file is copied to app sandbox
- ✅ File validation confirms ePub format
- ✅ Error alert shown for invalid files

### Playback
- ✅ Audio plays after file import
- ✅ Play button toggles playback state
- ✅ Pause button stops audio playback
- ✅ Stop button resets timeline to 0:00
- ✅ Playback rate slider adjusts speed (0.5x - 2.0x)

### Progress Tracking
- ✅ Progress bar shows current position
- ✅ Time display updates during playback
- ✅ Duration displays total audio length
- ✅ Format switches to HH:MM:SS for files >1 hour

### Chapter Navigation
- ✅ Chapter buttons appear for multi-chapter books
- ✅ Tapping chapter button jumps to that chapter
- ✅ Chapter title updates in UI
- ✅ Single-chapter books hide chapter navigation

### Error Handling
- ✅ Invalid file format shows clear error message
- ✅ Missing file shows error with recovery suggestions
- ✅ Large files (>200MB) rejected with memory warning
- ✅ App doesn't crash on any error condition

### Status Indicators
- ✅ Status shows current playback state
- ✅ Icons reflect state (play, pause, error, etc.)
- ✅ Loading spinner appears during import
- ✅ UI updates smoothly without visual glitches

---

## Requirements Traceability Matrix

### Phase 2: Services (Unit Tests)
- Tests: FileService, EPubService, AudioService
- Coverage: >90%

### Phase 3: Integration Tests
- Tests: Complete workflows (import → parse → playback)
- Coverage: All user journeys

### Phase 4: Comprehensive Tests
- Tests: Edge cases, performance, memory, UI state
- Coverage: >80% overall

---

**Last Updated**: 2026-02-27  
**Current Release**: 1.0 (Audio Player MVP)  
**Status**: Production Ready ✅
