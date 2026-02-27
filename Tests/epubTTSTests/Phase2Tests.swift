import XCTest
@testable import epubTTSCore

final class Phase2Tests: XCTestCase {
    
    // MARK: - AudioPlayerError Tests
    
    func testAudioPlayerErrorLocalizedDescription() {
        let error = AudioPlayerError.fileNotFound(path: "/test/path")
        XCTAssertEqual(error.errorDescription, "File not found: /test/path")
    }
    
    func testAudioPlayerErrorInvalidFile() {
        let error = AudioPlayerError.invalidFile(reason: "Missing metadata")
        XCTAssertEqual(error.errorDescription, "Unsupported file format: Missing metadata")
    }
    
    func testAudioPlayerErrorInsufficientMemory() {
        let error = AudioPlayerError.insufficientMemory(required: 250, available: 200)
        XCTAssertTrue(error.errorDescription?.contains("250") ?? false)
    }
    
    func testAudioPlayerErrorFileAccessDenied() {
        let error = AudioPlayerError.fileAccessDenied(path: "/test/path")
        XCTAssertTrue(error.errorDescription?.contains("Access denied") ?? false)
    }
    
    func testAudioPlayerErrorFailedToSynthesizeAudio() {
        let error = AudioPlayerError.failedToSynthesizeAudio(reason: "Invalid text")
        XCTAssertTrue(error.errorDescription?.contains("synthesize") ?? false)
    }
    
    func testAudioPlayerErrorAudioPlaybackFailed() {
        let error = AudioPlayerError.audioPlaybackFailed(reason: "Device muted")
        XCTAssertTrue(error.errorDescription?.contains("playback failed") ?? false)
    }
    
    // MARK: - AudioStatus Tests
    
    func testAudioStatusValues() {
        XCTAssertTrue(AudioStatus.idle.icon == "pause.circle.fill")
        XCTAssertTrue(AudioStatus.playing.isPlaying)
        XCTAssertFalse(AudioStatus.idle.isPlaying)
    }
    
    // MARK: - Model Tests
    
    func testEPubMetadataInitialization() {
        let metadata = EPubMetadata(
            title: "Test Book",
            author: "Test Author",
            language: "en",
            chapterCount: 5
        )
        XCTAssertEqual(metadata.title, "Test Book")
        XCTAssertEqual(metadata.author, "Test Author")
        XCTAssertEqual(metadata.chapterCount, 5)
    }
    
    func testEPubChapterInitialization() {
        let chapter = EPubChapter(
            number: 1,
            title: "Chapter One",
            text: "This is chapter one content."
        )
        XCTAssertEqual(chapter.number, 1)
        XCTAssertEqual(chapter.title, "Chapter One")
        XCTAssertTrue(chapter.text.count > 0)
    }
    
    func testEPubFileInitialization() {
        let metadata = EPubMetadata(
            title: "Test Book",
            author: nil,
            language: "en",
            chapterCount: 1
        )
        let chapter = EPubChapter(number: 1, title: "Ch1", text: "Content")
        let fileURL = URL(fileURLWithPath: "/test/test.epub")
        
        let epubFile = EPubFile(
            metadata: metadata,
            chapters: [chapter],
            fileURL: fileURL
        )
        
        XCTAssertEqual(epubFile.metadata.title, "Test Book")
        XCTAssertEqual(epubFile.chapters.count, 1)
    }
    
    func testLoggerInitialization() {
        let logger = Logger()
        XCTAssertNotNil(logger)
    }
}
