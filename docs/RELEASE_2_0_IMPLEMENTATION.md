# Release 2.0: Reader MVP - Implementation Plan

**Target**: Q3 2026  
**Team**: Single Developer + GitHub Copilot  
**Duration**: 8 weeks  
**Status**: Planning

---

## Implementation Phases

### Phase 1: Core Data & Text Parsing (Week 1-2)

#### Tasks

**Task 1.1: Core Data Setup** (3 days)
- [ ] Create Core Data model file (.xcdatamodeld)
- [ ] Define BookmarkEntity with relationships
- [ ] Define HighlightEntity with relationships
- [ ] Define ReadingProgressEntity
- [ ] Create Core Data stack (CoreDataStack.swift)
- [ ] Implement migration strategy
- **Tests**: Data model validation

**Task 1.2: Text Models** (2 days)
- [ ] Create TextChunk struct
  - Properties: id, startIndex, endIndex, text, duration
- [ ] Create Bookmark struct (from BookmarkEntity)
- [ ] Create Highlight struct (from HighlightEntity)
- [ ] Create HighlightColor enum
- **Tests**: Model initialization, encoding/decoding

**Task 1.3: HTML Parser Service** (4 days)
- [ ] Research HTML parsing libraries (SwiftSoup, Fuzi)
- [ ] Implement HTMLParser.swift
  - Extract text content from HTML
  - Preserve paragraph breaks
  - Handle special characters
- [ ] Implement text cleaning (remove scripts, styles)
- [ ] Handle common HTML elements (p, h1-h3, br, etc.)
- **Tests**: 10+ test cases for different HTML structures

**Task 1.4: CSS Parser Service** (3 days)
- [ ] Implement CSSParser.swift
  - Extract font-size, font-weight, text-align
  - Handle inline styles and external CSS
- [ ] Create StyleInfo struct
- [ ] Map CSS to SwiftUI modifiers
- **Tests**: Common CSS properties

**Task 1.5: Text Chunking** (2 days)
- [ ] Implement sentence-level chunking
- [ ] Implement word-level chunking (for long sentences)
- [ ] Calculate character positions for highlights
- [ ] Create ChunkingService.swift
- **Tests**: Chunking algorithm edge cases

**Deliverables**: 
- ✅ Core Data model
- ✅ HTML parser working
- ✅ Text chunks created with positions
- ✅ 20+ unit tests

---

### Phase 2: Synchronization & Services (Week 3-4)

#### Tasks

**Task 2.1: Sync Service** (4 days)
- [ ] Create SyncService.swift
- [ ] Implement duration calculation
  - Estimate TTS time per chunk based on word count
  - Formula: (word_count / words_per_minute) * 60
  - Default: 150 words per minute
- [ ] Track current playback time
- [ ] Determine active chunk at any playback time
- [ ] Handle playback rate changes
- [ ] Optimize for performance (lazy loading)
- **Tests**: Duration calculation, chunk tracking

**Task 2.2: Bookmark Service** (3 days)
- [ ] Create BookmarkService.swift
- [ ] Implement CRUD operations
  - Create: save bookmark with metadata
  - Read: fetch all bookmarks for a book
  - Update: modify bookmark note
  - Delete: remove bookmark
- [ ] Query by book ID
- [ ] Sort by date created
- [ ] Use Core Data for persistence
- **Tests**: All CRUD operations, persistence

**Task 2.3: Highlight Service** (3 days)
- [ ] Create HighlightService.swift
- [ ] Implement CRUD for highlights
- [ ] Track character ranges
- [ ] Support multiple colors
- [ ] Query highlights in text range
- [ ] Batch operations (highlight multiple selections)
- **Tests**: CRUD, range queries

**Task 2.4: Reader ViewModel** (3 days)
- [ ] Create ReaderViewModel.swift
- [ ] @Published properties:
  - currentChapter
  - displayText
  - currentHighlightedChunk
  - bookmarks
  - highlights
- [ ] Methods:
  - loadChapter(index)
  - addBookmark(position, note)
  - removeBookmark(id)
  - addHighlight(range, color)
  - removeHighlight(id)
  - syncWithPlayback(currentTime)
- **Tests**: ViewModel state management

**Task 2.5: Integration Tests** (3 days)
- [ ] Test sync between audio and text
- [ ] Test bookmark creation and retrieval
- [ ] Test highlight persistence
- [ ] Test Core Data operations
- [ ] Performance tests
- **Tests**: 15+ integration tests

**Deliverables**:
- ✅ SyncService with accurate timing
- ✅ BookmarkService with persistence
- ✅ HighlightService with range tracking
- ✅ ReaderViewModel with state management
- ✅ 30+ tests (total)

---

### Phase 3: UI Components (Week 5-6)

#### Tasks

**Task 3.1: Text Display View** (3 days)
- [ ] Create TextDisplayView.swift
- [ ] Render chapter text with styling
- [ ] Apply CSS styles to text attributes
- [ ] Handle scrolling
- [ ] Responsive to text size changes
- [ ] Highlight currently spoken text
- **Tests**: UI snapshot tests, rendering tests

**Task 3.2: Highlight Overlay** (2 days)
- [ ] Create HighlightOverlayView.swift
- [ ] Render highlights over text
- [ ] Different colors for different highlights
- [ ] Tap to remove highlight
- [ ] Long-press to create highlight
- **Tests**: Touch interaction tests

**Task 3.3: Bookmark UI** (2 days)
- [ ] Create BookmarkListView.swift
- [ ] Display all bookmarks
- [ ] Tap to jump to bookmark
- [ ] Swipe to delete bookmark
- [ ] Add note to bookmark
- **Tests**: List interaction tests

**Task 3.4: Reader View Integration** (2 days)
- [ ] Create main ReaderView.swift
- [ ] Combine TextDisplayView + PlaybackControls
- [ ] Split-view layout (text + controls)
- [ ] Responsive to orientation changes
- **Tests**: Layout tests, responsive tests

**Task 3.5: Auto-Scroll** (2 days)
- [ ] Implement smooth scrolling to highlight
- [ ] Center highlight on screen
- [ ] Debounce scroll updates
- [ ] Option to disable auto-scroll
- **Tests**: Scroll animation tests

**Deliverables**:
- ✅ TextDisplayView with styling
- ✅ HighlightOverlayView with interactions
- ✅ BookmarkListView with actions
- ✅ Auto-scroll with smooth animation
- ✅ UI snapshot tests

---

### Phase 4: Persistence & Polish (Week 7)

#### Tasks

**Task 4.1: Core Data Persistence** (2 days)
- [ ] Test bookmark persistence
- [ ] Test highlight persistence
- [ ] Test data migration
- [ ] Implement backup/restore
- **Tests**: Persistence tests

**Task 4.2: Performance Optimization** (2 days)
- [ ] Profile memory usage
- [ ] Optimize HTML parsing
- [ ] Lazy load text for large books
- [ ] Cache parsed chapters
- [ ] Limit memory footprint
- **Tests**: Performance tests

**Task 4.3: Edge Cases** (2 days)
- [ ] Handle empty chapters
- [ ] Handle very long chapters (> 10,000 words)
- [ ] Handle unusual HTML structures
- [ ] Handle playback rate changes
- [ ] Handle chapter switching during playback
- **Tests**: Edge case tests

**Task 4.4: Documentation** (1 day)
- [ ] Update DESIGN.md
- [ ] Create API documentation
- [ ] Add code comments
- [ ] Update README

**Deliverables**:
- ✅ All features persisted
- ✅ Performance optimized
- ✅ Edge cases handled
- ✅ Documentation complete

---

### Phase 5: Testing & Release (Week 8+)

#### Tasks

**Task 5.1: Comprehensive Testing** (2 days)
- [ ] Integration tests for all features
- [ ] End-to-end tests
- [ ] Performance tests
- [ ] Memory leak detection
- [ ] Achieve 70%+ code coverage
- **Tests**: 50+ tests total

**Task 5.2: Bug Fixes** (1 day)
- [ ] Fix any issues found in testing
- [ ] Performance improvements
- [ ] UI/UX refinements

**Task 5.3: Release Preparation** (1 day)
- [ ] Update version to 2.0.0
- [ ] Create CHANGELOG
- [ ] Tag release on GitHub
- [ ] Create release notes

**Deliverables**:
- ✅ Release 2.0 ready
- ✅ All tests passing
- ✅ Documentation complete

---

## Task Breakdown Summary

| Phase | Tasks | Duration | Status |
|-------|-------|----------|--------|
| 1: Core Data & Parsing | 5 tasks | 2 weeks | ⏳ Pending |
| 2: Sync & Services | 5 tasks | 2 weeks | ⏳ Pending |
| 3: UI Components | 5 tasks | 2 weeks | ⏳ Pending |
| 4: Persistence & Polish | 4 tasks | 1 week | ⏳ Pending |
| 5: Testing & Release | 3 tasks | 1+ weeks | ⏳ Pending |
| **TOTAL** | **22 tasks** | **8+ weeks** | ⏳ Pending |

---

## Dependencies Between Tasks

```
Phase 1
├── Task 1.1 (Core Data) ──┐
├── Task 1.2 (Models)      ├──→ Phase 2
├── Task 1.3 (HTML Parser) │
├── Task 1.4 (CSS Parser)  │
└── Task 1.5 (Chunking)    │

Phase 2
├── Task 2.1 (SyncService) ──┐
├── Task 2.2 (BookmarkService)├──→ Phase 3
├── Task 2.3 (HighlightService)│
├── Task 2.4 (ViewModel)      │
└── Task 2.5 (Integration Tests)

Phase 3
├── Task 3.1 (TextDisplayView) ──┐
├── Task 3.2 (HighlightOverlay)  ├──→ Phase 4
├── Task 3.3 (BookmarkUI)        │
├── Task 3.4 (ReaderView)        │
└── Task 3.5 (Auto-Scroll)       │

Phase 4 & 5 (Sequential)
```

---

## Testing Strategy

### Unit Tests (Phase 1-2)
- HTML parser edge cases
- Text chunking algorithm
- Duration calculations
- Model CRUD operations

### Integration Tests (Phase 3-4)
- Text rendering with styles
- Sync between audio and text
- Bookmark persistence
- Highlight management

### End-to-End Tests (Phase 5)
- Complete reading workflow
- Playback + reading
- Bookmark creation and usage
- Highlight creation and persistence

### Performance Tests (Phase 5)
- Text rendering: < 500ms for 10,000 words
- Memory usage: < 100MB total
- Sync latency: < 200ms

---

## Risk Mitigation

| Risk | Mitigation | Owner |
|------|-----------|-------|
| HTML parsing library not available | Pre-research libraries early | Dev |
| Core Data complexity | Early spike/prototype | Dev |
| Sync timing not accurate | Allow manual offset tuning | Dev |
| Performance issues with large books | Profile early, implement lazy loading | Dev |
| Memory leaks | Regular profiling, automated tests | Dev |

---

## Success Metrics

### Code Quality
- [ ] 70%+ code coverage
- [ ] 0 critical bugs
- [ ] All tests passing
- [ ] Code review approved

### Performance
- [ ] App launch: < 2 seconds
- [ ] Text rendering: < 500ms
- [ ] Sync latency: < 200ms
- [ ] Memory: < 100MB additional

### User Experience
- [ ] 4.5+ star rating
- [ ] Smooth playback
- [ ] Accurate synchronization
- [ ] Intuitive UI

---

## Rollout Plan

### Beta (Internal Testing)
1. Build and test locally
2. Test with 5-10 different ePub files
3. Performance testing
4. Bug fixes

### Release Candidate
1. Final testing
2. Release notes preparation
3. GitHub tag creation

### Production Release
1. Tag release: v2.0.0
2. Create release notes
3. Monitor for issues

---

## Monitoring & Feedback

### Metrics to Track
- Crash rate
- Memory usage patterns
- Feature usage (bookmarks, highlights)
- User feedback

### Feedback Channels
- GitHub Issues
- App Store reviews
- In-app crash reporting (Phase 3+)

---

## Next Steps

1. ✅ Design complete (RELEASE_2_0_DESIGN.md)
2. ✅ Implementation plan complete (this document)
3. ⏳ Start Phase 1: Core Data & Text Parsing
4. ⏳ Daily standups during development
5. ⏳ Weekly progress reviews

---

**Ready to start Phase 1!** 🚀

See RELEASE_2_0_DESIGN.md for architecture details.
