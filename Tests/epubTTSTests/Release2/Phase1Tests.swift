import XCTest
@testable import epubTTSCore
@testable import epubTTSReader

final class Phase1Tests: XCTestCase {
    
    // MARK: - TextChunk Tests
    
    func testTextChunkInitialization() {
        let chunk = TextChunk(
            startIndex: 0,
            endIndex: 10,
            text: "Hello",
            duration: 2.5
        )
        
        XCTAssertEqual(chunk.startIndex, 0)
        XCTAssertEqual(chunk.endIndex, 10)
        XCTAssertEqual(chunk.text, "Hello")
        XCTAssertEqual(chunk.duration, 2.5)
        XCTAssertEqual(chunk.length, 5)
    }
    
    func testTextChunkCodable() throws {
        let chunk = TextChunk(
            startIndex: 0,
            endIndex: 10,
            text: "Hello World",
            duration: 3.0
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(chunk)
        
        let decoder = JSONDecoder()
        let decodedChunk = try decoder.decode(TextChunk.self, from: data)
        
        XCTAssertEqual(decodedChunk.text, chunk.text)
        XCTAssertEqual(decodedChunk.duration, chunk.duration)
    }
    
    // MARK: - Highlight Tests
    
    func testHighlightInitialization() {
        let highlight = Highlight(
            bookId: "book123",
            chapterIndex: 0,
            startIndex: 5,
            endIndex: 15,
            color: .yellow
        )
        
        XCTAssertEqual(highlight.bookId, "book123")
        XCTAssertEqual(highlight.chapterIndex, 0)
        XCTAssertEqual(highlight.color, .yellow)
    }
    
    func testHighlightColorDisplayName() {
        XCTAssertEqual(HighlightColor.yellow.displayName, "Yellow")
        XCTAssertEqual(HighlightColor.orange.displayName, "Orange")
        XCTAssertEqual(HighlightColor.pink.displayName, "Pink")
        XCTAssertEqual(HighlightColor.purple.displayName, "Purple")
        XCTAssertEqual(HighlightColor.blue.displayName, "Blue")
        XCTAssertEqual(HighlightColor.green.displayName, "Green")
    }
    
    // MARK: - Bookmark Tests
    
    func testBookmarkInitialization() {
        let bookmark = Bookmark(
            bookId: "book123",
            chapterIndex: 2,
            position: 120.5,
            note: "Great passage"
        )
        
        XCTAssertEqual(bookmark.bookId, "book123")
        XCTAssertEqual(bookmark.chapterIndex, 2)
        XCTAssertEqual(bookmark.position, 120.5)
        XCTAssertEqual(bookmark.note, "Great passage")
    }
    
    func testBookmarkCodable() throws {
        let bookmark = Bookmark(
            bookId: "book456",
            chapterIndex: 1,
            position: 85.0,
            note: "Important"
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(bookmark)
        
        let decoder = JSONDecoder()
        let decodedBookmark = try decoder.decode(Bookmark.self, from: data)
        
        XCTAssertEqual(decodedBookmark.bookId, bookmark.bookId)
        XCTAssertEqual(decodedBookmark.note, bookmark.note)
    }
    
    // MARK: - HTMLParser Tests
    
    func testHTMLParserSimpleText() {
        let html = "<p>Hello World</p>"
        let text = HTMLParser.parseText(html)
        XCTAssertEqual(text, "Hello World")
    }
    
    func testHTMLParserStripTags() {
        let html = "<h1>Title</h1><p>Content here</p>"
        let text = HTMLParser.parseText(html)
        XCTAssertTrue(text.contains("Title"))
        XCTAssertTrue(text.contains("Content here"))
        XCTAssertFalse(text.contains("<"))
        XCTAssertFalse(text.contains(">"))
    }
    
    func testHTMLParserEntities() {
        let html = "<p>&lt;Hello&gt; &amp; Welcome</p>"
        let text = HTMLParser.parseText(html)
        XCTAssertTrue(text.contains("<Hello>"))
        XCTAssertTrue(text.contains("&"))
    }
    
    func testHTMLParserNestedTags() {
        let html = "<div><p><b>Bold text</b></p></div>"
        let text = HTMLParser.parseText(html)
        XCTAssertTrue(text.contains("Bold text"))
    }
    
    func testHTMLParserFormatting() {
        let html = "<p><b>Bold</b> and <i>italic</i></p>"
        let formatted = HTMLParser.parseWithFormatting(html)
        XCTAssertGreaterThan(formatted.count, 0)
    }
    
    // MARK: - CSSParser Tests
    
    func testCSSParserInlineStyle() {
        let styleString = "font-size: 16px; font-weight: bold; text-align: center"
        let style = CSSParser.parseInlineStyle(styleString)
        
        XCTAssertEqual(style.fontSize, 16)
        XCTAssertEqual(style.fontWeight, 700)
        XCTAssertEqual(style.textAlign, .center)
        XCTAssertTrue(style.isBold)
    }
    
    func testCSSParserFontWeight() {
        let boldStyle = CSSParser.parseInlineStyle("font-weight: bold")
        XCTAssertEqual(boldStyle.fontWeight, 700)
        XCTAssertTrue(boldStyle.isBold)
        
        let normalStyle = CSSParser.parseInlineStyle("font-weight: normal")
        XCTAssertEqual(normalStyle.fontWeight, 400)
        XCTAssertFalse(normalStyle.isBold)
    }
    
    func testCSSParserItalic() {
        let italicStyle = CSSParser.parseInlineStyle("font-style: italic")
        XCTAssertTrue(italicStyle.isItalic)
    }
    
    func testCSSParserFontSizeForElements() {
        XCTAssertEqual(CSSParser.getDefaultFontSize(for: "h1"), 32)
        XCTAssertEqual(CSSParser.getDefaultFontSize(for: "h2"), 28)
        XCTAssertEqual(CSSParser.getDefaultFontSize(for: "p"), 16)
        XCTAssertEqual(CSSParser.getDefaultFontSize(for: "small"), 12)
    }
    
    // MARK: - ChunkingService Tests
    
    func testChunkingServiceInitialization() {
        let service = ChunkingService(wordsPerMinute: 150)
        XCTAssertNotNil(service)
    }
    
    func testChunkingServiceCalculateDuration() {
        let service = ChunkingService(wordsPerMinute: 60) // 1 word per second
        let duration = service.calculateDuration(for: "One two three four five")
        
        // 5 words at 60 WPM = 5 seconds
        XCTAssertGreaterThan(duration, 4.0)
        XCTAssertLessThan(duration, 6.0)
    }
    
    func testChunkingServiceChunkBySentences() {
        let text = "First sentence. Second sentence. Third sentence."
        let service = ChunkingService()
        let chunks = service.chunkBySentences(text)
        
        XCTAssertGreaterThan(chunks.count, 0)
        XCTAssertTrue(chunks.allSatisfy { $0.duration > 0 })
    }
    
    func testChunkingServiceFindChunkAtTime() {
        let service = ChunkingService(wordsPerMinute: 60)
        let text = "one two three four five six seven eight nine ten"
        let chunks = service.chunkByWords(text)
        
        XCTAssertGreaterThan(chunks.count, 0)
        
        // Find chunk at first word (time = 0)
        if let chunk = service.findChunkAtTime(chunks, time: 0) {
            XCTAssertEqual(chunk.text, "one")
        }
    }
    
    func testChunkingServiceWordCounting() {
        let service = ChunkingService()
        let text = "The quick brown fox jumps over the lazy dog"
        let duration = service.calculateDuration(for: text)
        
        // 9 words at 150 WPM = 3.6 seconds
        XCTAssertGreaterThan(duration, 3.0)
        XCTAssertLessThan(duration, 5.0)
    }
}
