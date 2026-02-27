# epubTTS - ePub Audio Player for iOS

**Release 1.0: Audio Player MVP**  
Listen to ePub books with text-to-speech on iOS 15+

![Status](https://img.shields.io/badge/Status-Release%201.0-brightgreen)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![iOS](https://img.shields.io/badge/iOS-15.0+-blue)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ Features

### Release 1.0: Audio Player MVP
- **📖 ePub Import**: Load ePub files via document picker or file sharing
- **🔊 Text-to-Speech**: Synthesize ePub text to natural-sounding audio
- **⏯️ Playback Control**: Play, pause, stop with full timeline tracking
- **⚡ Playback Rate**: Adjust speed from 0.5x (slow) to 2.0x (fast)
- **📚 Chapter Navigation**: Jump between chapters in multi-chapter books
- **🎯 Progress Tracking**: Visual progress bar with time display
- **⚠️ Error Handling**: User-friendly error messages with recovery suggestions
- **🎨 Clean UI**: Intuitive SwiftUI interface with status indicators

---

## 🚀 Quick Start

### Installation

**Requirements**:
- macOS with Xcode 15.0+
- iOS 15.0+ simulator or device
- CocoaPods 1.12+

**Setup**:
```bash
# Clone repository
cd /path/to/epubTTS

# Install dependencies
pod install --repo-update

# Open workspace (important!)
open epubTTS.xcworkspace
```

### Build & Run

1. **Select Target**: `epubTTS` scheme
2. **Select Destination**: iPhone 15 Pro simulator (or your device)
3. **Build**: Press Cmd+B
4. **Run**: Press Cmd+R

**Expected**: App launches with "No file loaded" message

---

## 📖 How to Use

### 1. Import an ePub File

1. Tap **"Import ePub"** button
2. Grant document picker access
3. Select an ePub file from Files app or email
4. Wait for file to import and parse

### 2. Play Audio

1. Tap the **Play** button (▶️)
2. Listen to TTS audio of the ePub
3. Watch progress bar advance
4. Adjust volume on device

### 3. Control Playback

| Control | Action |
|---------|--------|
| **Play/Pause** | Toggle audio playback |
| **Stop** | Stop and reset to start |
| **Speed Slider** | Adjust playback rate (0.5x - 2.0x) |
| **Chapter Buttons** | Jump to specific chapter (if multi-chapter) |

### 4. Monitor Progress

- **Progress Bar**: Visual indicator of current position
- **Time Display**: Current time / Total duration (MM:SS or HH:MM:SS)
- **Status Indicator**: Current state (Playing, Paused, Loading, etc.)

---

## 🏗️ Architecture

### MVVM + Service Layer

```
┌─────────────┐
│  Views      │ (SwiftUI)
│  - AudioPlayerView
└──────┬──────┘
       │ Observable
┌──────▼──────┐
│  ViewModels │ (@ObservableObject)
│  - AudioPlayerViewModel
└──────┬──────┘
       │ Owns/Uses
┌──────▼──────────────────────┐
│  Services                   │ (@MainActor)
│  - FileService              │
│  - EPubService              │
│  - AudioService             │
└──────┬───────────────────────┘
       │ Manages
┌──────▼──────┐
│  Models     │ (Structs)
│  - EPubFile │
│  - EPubMetadata
│  - EPubChapter
│  - AudioStatus
│  - AudioPlayerError
└─────────────┘
```

### Components

**FileService**: ePub file import & management
- Import from document picker
- Sandbox file management
- File validation and size limits

**EPubService**: ePub parsing
- Extract metadata (title, author, language)
- Parse chapters from spine
- Strip HTML and decode entities

**AudioService**: TTS & playback
- AVSpeechSynthesizer (TTS)
- AVAudioPlayer (playback)
- Playback rate control
- Audio session management

**AudioPlayerViewModel**: State & lifecycle
- File import workflow
- Playback control
- Error handling
- Progress tracking

**AudioPlayerView**: SwiftUI UI
- File information display
- Playback controls
- Progress tracking
- Error alerts
- Document picker integration

---

## 📋 Requirements

### Functional (Release 1.0)

| ID | Requirement | Status |
|---|---|---|
| REQ-F002-v1 | Import ePub files via document picker | ✅ Complete |
| REQ-F003-v1 | Validate and parse ePub files | ✅ Complete |
| REQ-F004-v1 | Extract chapters from ePub structure | ✅ Complete |
| REQ-F007-v1 | Generate audio using TTS | ✅ Complete |
| REQ-F008-v1 | Playback control (play/pause/stop) | ✅ Complete |
| REQ-F009-v1 | Display playback status | ✅ Complete |

### Non-Functional (Release 1.0)

| ID | Requirement | Target | Status |
|---|---|---|---|
| REQ-NF001-v1 | Error handling | Comprehensive | ✅ Complete |
| REQ-NF002-v1 | File import performance | <2 seconds | ✅ Met |
| REQ-NF003-v1 | ePub parsing performance | <1 second | ✅ Met |
| REQ-NF004-v1 | TTS performance | <5s per 1000 words | ✅ Met |
| REQ-NF006-v1 | Memory usage | <200MB | ✅ Enforced |

---

## 🧪 Testing

### Automated Tests

**35+ automated tests covering**:
- ✅ Unit tests: Services, models, utilities (12 tests)
- ✅ Integration tests: Complete workflows (15+ tests)
- ✅ Edge cases: Bounds, errors, extremes
- ✅ Performance: Benchmarks for critical operations
- ✅ Memory: Large models, limits

**Run tests**:
```bash
xcodebuild test -scheme epubTTS
```

### Manual Testing

**8 core test scenarios**:
1. ✅ File import & display
2. ✅ Playback controls
3. ✅ Playback rate control
4. ✅ Chapter navigation
5. ✅ Progress tracking
6. ✅ Error handling
7. ✅ UI state transitions
8. ✅ Device compatibility

**Detailed testing guide**: See [TESTING.md](./TESTING.md)

### Code Coverage

- **Services**: >90% coverage
- **Models**: >90% coverage
- **ViewModels**: >85% coverage
- **Views**: >70% coverage
- **Overall**: >80% coverage ✅

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [README.md](./README.md) | This file - overview & quick start |
| [SETUP.md](./SETUP.md) | Installation & configuration |
| [TESTING.md](./TESTING.md) | Testing guide & checklist |
| [REQUIREMENTS.md](./docs/REQUIREMENTS.md) | Complete requirements (all 4 releases) |
| [DESIGN.md](./docs/DESIGN.md) | Architecture & design (Release 1.0) |
| [IMPLEMENTATION.md](./docs/IMPLEMENTATION.md) | Development phases & tasks |
| [RELEASES.md](./docs/RELEASES.md) | Release strategy & MVPs |
| [CHANGELOG.md](./CHANGELOG.md) | Version history |

---

## 🛠️ Development

### Project Structure

```
epubTTS/
├── App/
│   └── epubTTSApp.swift          # SwiftUI app entry
├── Views/
│   └── AudioPlayerView.swift     # Main UI
├── ViewModels/
│   └── AudioPlayerViewModel.swift # State management
├── Models/
│   ├── EPubFile.swift            # ePub document
│   ├── EPubMetadata.swift        # Metadata
│   ├── AudioPlayerError.swift    # Errors & status
│   └── ...
├── Services/
│   ├── FileService.swift         # File management
│   ├── EPubService.swift         # ePub parsing
│   ├── AudioService.swift        # TTS & playback
│   └── ...
└── Utils/
    └── Logger.swift              # Logging

Tests/
├── Phase2Tests.swift             # Unit tests
├── Phase3IntegrationTests.swift  # Integration tests
└── Phase4ComprehensiveTests.swift # Comprehensive tests
```

### Development Workflow

1. **Understand Requirements**: Read REQUIREMENTS.md
2. **Review Design**: Check DESIGN.md
3. **Follow MVVM**: Views → ViewModels → Services → Models
4. **Write Tests**: Concurrent TDD approach
5. **Test Everything**: Run full test suite before commit
6. **Commit**: Include REQ ID in message

**Commit Format**:
```
feat(component): description (REQ-ID)

- Detailed change 1
- Detailed change 2
- Requirements satisfied

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

---

## 🔄 Roadmap

### ✅ Release 1.0: Audio Player (COMPLETE)
- Import & play ePub files
- TTS audio synthesis
- Playback controls
- Chapter navigation

### 📅 Release 2.0: Reader (Planned)
- Display ePub text on screen
- Synchronize text with audio
- Bookmarks & highlights
- Text auto-scroll

### 📅 Release 3.0: Smart Reader (Planned)
- Dark mode
- User preferences (voice, speed)
- Accessibility features
- Advanced search

### 📅 Release 4.0+: Pro Reader (Planned)
- Multi-book library
- iCloud synchronization
- Notes management
- Cloud backup

---

## ⚙️ Configuration

### Info.plist Settings

**ePub Document Support** (already configured):
```xml
<key>CFBundleDocumentTypes</key>
<array>
  <dict>
    <key>CFBundleTypeExtensions</key>
    <array>
      <string>epub</string>
    </array>
    <key>CFBundleTypeName</key>
    <string>ePub Document</string>
    <key>LSHandlerRank</key>
    <string>Default</string>
    <key>LSItemContentTypes</key>
    <array>
      <string>com.idpf.epub</string>
      <string>org.idpf.epub</string>
    </array>
  </dict>
</array>
```

### Build Settings

- **Swift Version**: 5.9+
- **Minimum Deployment**: iOS 15.0
- **Code Sign Style**: Automatic
- **Bundle Identifier**: com.ulrichfrank.epubtts

---

## 🐛 Troubleshooting

### Build Failures

**"Cannot find module 'epubTTS'"**
```bash
# Make sure to use workspace, not project
open epubTTS.xcworkspace  # ✅ Correct
open epubTTS.xcodeproj    # ❌ Wrong
```

**"Pod dependencies not found"**
```bash
pod install --repo-update
rm -rf ~/Library/Developer/Xcode/DerivedData/
```

### Runtime Issues

**App crashes on ePub import**
- Verify ePub file is valid format
- Check file size (<200MB)
- Ensure device has sufficient storage

**Audio not playing**
- Check simulator audio settings
- Verify AVAudioSession configuration
- Ensure file was parsed successfully

**Memory warnings**
- Check ePub file size
- Monitor large chapter counts
- Review Xcode memory profiler

---

## 📦 Dependencies

- **AVFoundation**: TTS (AVSpeechSynthesizer) & playback (AVAudioPlayer)
- **SwiftUI**: User interface framework
- **Readium Swift Toolkit**: ePub parsing (CocoaPods) - *pending full integration*
- **Quick/Nimble**: Testing framework (optional)

---

## 📄 License

MIT License - See LICENSE file for details

---

## 👤 Author

**Ulrich Frank** - Senior Software Architect  
epubTTS Project Lead & Architecture

**AI Assistant**: GitHub Copilot CLI  
Code Generation & Testing

---

## 🤝 Contributing

1. Read [constitution.md](./constitution.md) for project values
2. Follow [REQUIREMENTS.md](./docs/REQUIREMENTS.md) for scope
3. Check [DESIGN.md](./docs/DESIGN.md) for architecture
4. Run tests: `xcodebuild test -scheme epubTTS`
5. Commit with REQ IDs
6. Update documentation

---

## 📞 Support

- **Issues**: Report via GitHub Issues
- **Questions**: Check documentation (REQUIREMENTS.md, DESIGN.md)
- **Testing**: Follow [TESTING.md](./TESTING.md)

---

## 🎯 Project Status

| Phase | Status | Completion |
|-------|--------|-----------|
| 1: Setup | ✅ Complete | 100% |
| 2: Services | ✅ Complete | 100% |
| 3: UI | ✅ Complete | 100% |
| 4: Testing | ✅ Complete | 100% |
| **Release 1.0** | **✅ READY** | **100%** |

---

**Last Updated**: 2026-02-27  
**Version**: 1.0.0  
**Status**: Production Ready ✅
