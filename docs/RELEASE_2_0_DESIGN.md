# 📖 Release 2.0: Reader MVP - Design Document

**Status**: Planning  
**Target Release**: Q3 2026  
**Core Value**: Read text and listen simultaneously with sync

---

## 1. Overview

Release 2.0 builds on Release 1.0 (Audio Player MVP) by adding on-screen text rendering with text-to-speech synchronization. Users can now read the ePub text while listening to the audio, with the current text being highlighted as it's spoken.

### Core Concept
```
Release 1.0: Listen to ePubs (audio only)
    ↓
Release 2.0: Read and listen together (with sync)
    ↓
Release 3.0: Personalized experience (themes, voices)
```

---

## 2. Features

### 2.1 On-Screen Text Display (REQ-F010-v2)

**Description**: Render ePub text content on screen using SwiftUI  
**User Benefit**: See the book content while listening

#### Implementation Details
- Parse XHTML/HTML content from ePub chapters
- Render text with SwiftUI Text components
- Support for scrollable chapter view
- Clean typography with proper line spacing
- Responsive to device orientation

#### Technical Approach
```
ePubChapter.text
    ↓
HTMLParser (extract plain text + formatting)
    ↓
TextModel (with position tracking)
    ↓
SwiftUI TextView
```

### 2.2 CSS Styling Support (REQ-F011-v2)

**Description**: Parse and apply basic CSS styling from ePub  
**User Benefit**: Books display with intended formatting

#### Supported Styles
- Font sizes (h1, h2, h3, p)
- Font weights (bold, italic)
- Text alignment (left, center, right)
- Margins and padding (visual separation)
- Line height for readability

#### Not Supported (Phase 3+)
- Images and graphics
- Complex layouts
- CSS animations
- Advanced selectors

### 2.3 Text-to-Audio Synchronization (REQ-F012-v2)

**Description**: Highlight currently spoken text during playback  
**User Benefit**: Users can follow along with the audio

#### How It Works
```
1. AudioService speaks text chunk-by-chunk
2. Each spoken chunk is tracked with duration
3. Current playback time compared to chunk timings
4. Matching chunk is highlighted in UI
5. View automatically scrolls to highlighted text
```

#### Implementation Strategy
- Divide chapter text into sentences or words
- Calculate speaking duration for each chunk (TTS speed dependent)
- Track current playback position
- Update highlight in real-time

#### Challenges & Solutions
| Challenge | Solution |
|-----------|----------|
| TTS timing not exact | Pre-calculate durations, adjust in real-time |
| Text chunking | Split by sentences, then words if needed |
| Performance with long text | Use lazy rendering for off-screen text |
| Different playback rates | Recalculate durations based on rate |

### 2.4 Bookmark System (REQ-F013-v2)

**Description**: Save and resume from bookmarked positions  
**User Benefit**: Pause reading and continue later at exact position

#### Features
- Add bookmark at current playback position
- Delete bookmarks
- List all bookmarks for a book
- Jump to bookmarked position
- Persist bookmarks (Core Data)

#### Data Model
```swift
struct Bookmark {
    let id: UUID
    let bookId: String        // epubFile.id
    let chapterIndex: Int
    let position: TimeInterval
    let timestamp: Date
    let note: String?
}
```

#### Storage
- Core Data for persistence
- Device-local only (no cloud sync in v2)

### 2.5 Text Highlighting (REQ-F014-v2)

**Description**: Users can select and highlight text  
**User Benefit**: Mark important passages

#### Features
- Long-press to select text
- Tap to highlight/unhighlight
- Multiple highlights per book
- Color-coded highlights

#### Data Model
```swift
struct Highlight {
    let id: UUID
    let bookId: String
    let chapterIndex: Int
    let startIndex: Int      // character position
    let endIndex: Int
    let color: HighlightColor
    let timestamp: Date
}
```

### 2.6 Auto-Scroll (REQ-F015-v2)

**Description**: Text automatically scrolls during playback  
**User Benefit**: Users don't need to scroll manually

#### Behavior
- Scroll keeps highlighted text centered on screen
- Smooth animation (not jarring)
- Disabled option in preferences
- Works with different text sizes

---

## 3. Architecture

### 3.1 New Components

```
┌─────────────────────────────────────────────┐
│          SwiftUI Views                      │
│  ┌──────────────────────────────────────┐   │
│  │ ReaderView (Main Reader UI)          │   │
│  │ ├── TextDisplayView (Chapter text)   │   │
│  │ ├── PlaybackControlsView             │   │
│  │ ├── BookmarkListView                 │   │
│  │ └── HighlightOverlay                 │   │
│  └──────────────────────────────────────┘   │
├─────────────────────────────────────────────┤
│          ViewModels                         │
│  ┌──────────────────────────────────────┐   │
│  │ ReaderViewModel                      │   │
│  │ ├── Text synchronization             │   │
│  │ ├── Bookmark management              │   │
│  │ └── Highlight management             │   │
│  └──────────────────────────────────────┘   │
├─────────────────────────────────────────────┤
│          Services                           │
│  ┌──────────────────────────────────────┐   │
│  │ TextRenderingService                 │   │
│  │ ├── HTML parsing                     │   │
│  │ ├── CSS styling                      │   │
│  │ └── Text layout                      │   │
│  │                                      │   │
│  │ SyncService                          │   │
│  │ ├── Chunk duration calculation       │   │
│  │ ├── Highlight tracking               │   │
│  │ └── Scroll management                │   │
│  │                                      │   │
│  │ BookmarkService                      │   │
│  │ ├── CRUD operations                  │   │
│  │ ├── Core Data management             │   │
│  │ └── Querying                         │   │
│  └──────────────────────────────────────┘   │
├─────────────────────────────────────────────┤
│          Models (Core Data)                 │
│  ├── BookmarkEntity                        │
│  ├── HighlightEntity                       │
│  └── ReadingProgressEntity                 │
└─────────────────────────────────────────────┘
```

### 3.2 Data Flow

```
1. User opens book
   AudioPlayerViewModel loads ePubFile
   ReaderViewModel loads chapter text

2. TextRenderingService parses text
   HTMLParser extracts content and styles
   TextChunks created with position info

3. User starts playback
   AudioService speaks text chunk-by-chunk
   SyncService tracks current chunk

4. During playback
   Current time → SyncService
   SyncService determines current chunk
   ReaderViewModel updates highlight
   View re-renders with new highlight

5. User creates bookmark
   BookmarkService saves to Core Data
   Timestamp and position recorded

6. User highlights text
   HighlightService saves to Core Data
   Overlay updates on text change
```

### 3.3 Threading

- **Main Thread**: UI updates, SwiftUI rendering
- **Background**: Core Data operations, HTML parsing
- **Audio Thread**: AVFoundation (managed by Release 1.0)

All Services remain @MainActor for SwiftUI integration.

---

## 4. Technology Stack

### New Dependencies
| Library | Purpose | Version |
|---------|---------|---------|
| SwiftSoup or Fuzi | HTML parsing | Latest |
| Core Data | Local persistence | Built-in |
| ConcurrentHashMap (if needed) | Thread-safe caching | Swift stdlib |

### No Breaking Changes
- Release 1.0 code remains unchanged
- New components added to Package.swift
- Optional feature (can be disabled)

---

## 5. File Structure

```
Sources/
├── Core/                    # Release 1.0 (unchanged)
│   ├── AudioPlayerError.swift
│   ├── AudioStatus.swift
│   ├── EPubFile.swift
│   ├── EPubChapter.swift
│   ├── EPubMetadata.swift
│   ├── FileService.swift
│   ├── EPubService.swift
│   └── Logger.swift
│
├── Reader/                  # Release 2.0 (new)
│   ├── Models/
│   │   ├── TextChunk.swift
│   │   ├── Bookmark.swift
│   │   ├── Highlight.swift
│   │   ├── BookmarkEntity+CoreData.swift
│   │   └── HighlightEntity+CoreData.swift
│   │
│   ├── Services/
│   │   ├── TextRenderingService.swift
│   │   ├── HTMLParser.swift
│   │   ├── CSSParser.swift
│   │   ├── SyncService.swift
│   │   ├── BookmarkService.swift
│   │   └── HighlightService.swift
│   │
│   └── ViewModels/
│       └── ReaderViewModel.swift
│
└── App/
    └── (UI Views - separate from structure)
```

---

## 6. Phase Breakdown

### Phase 1: Foundation (Week 1-2)
- [ ] Set up Core Data models
- [ ] Create TextRenderingService with HTML parsing
- [ ] Implement text chunking algorithm
- [ ] Create TextChunk model

### Phase 2: Synchronization (Week 3-4)
- [ ] Create SyncService
- [ ] Implement duration calculation
- [ ] Build highlight tracking
- [ ] Create ReaderViewModel

### Phase 3: UI (Week 5-6)
- [ ] Build TextDisplayView
- [ ] Implement highlight rendering
- [ ] Add auto-scroll
- [ ] Integrate with AudioPlayerView

### Phase 4: Persistence (Week 7)
- [ ] Create BookmarkService
- [ ] Create HighlightService
- [ ] Build bookmark UI
- [ ] Build highlight UI

### Phase 5: Testing & Polish (Week 8+)
- [ ] Integration tests
- [ ] Performance testing
- [ ] UI/UX refinement
- [ ] Release preparation

---

## 7. Success Criteria

### Functional
- [ ] Text displays correctly for all tested ePub files
- [ ] Synchronization is smooth (no lag > 100ms)
- [ ] Bookmarks persist across app restarts
- [ ] Highlights display correctly
- [ ] Auto-scroll is smooth and not distracting

### Non-Functional
- [ ] Text rendering performance: < 500ms for 10,000 words
- [ ] Sync latency: < 200ms between audio and highlight
- [ ] Memory usage: < 100MB additional
- [ ] Code coverage: > 70%
- [ ] App size increase: < 2MB

### User Experience
- [ ] Readable typography
- [ ] No jank during playback
- [ ] Intuitive bookmark/highlight UI
- [ ] Fast switching between chapters

---

## 8. Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| HTML parsing complexity | Schedule delay | Use proven library (SwiftSoup) |
| TTS timing inaccuracy | Poor sync UX | Allow manual offset adjustment |
| Core Data learning curve | Development time | Early spike with sample implementation |
| Performance with large books | Poor user experience | Implement lazy loading/chunking |
| Memory growth with caching | App crashes | Profile and limit cache size |

---

## 9. Future Considerations (Release 3+)

- Dark mode support
- User voice selection
- Speed presets
- VoiceOver integration
- Full-text search
- Cloud synchronization
- Reading statistics

---

## 10. References

- REQUIREMENTS.md - Detailed functional requirements
- RELEASES.md - Release strategy
- DESIGN.md - Overall architecture
- IMPLEMENTATION.md - Implementation phases

---

**Next Step**: Move to RELEASE_2_0_IMPLEMENTATION.md for detailed task breakdown
