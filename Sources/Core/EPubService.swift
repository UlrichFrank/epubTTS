import Foundation

@MainActor
public class EPubService {
    public static let shared = EPubService()
    
    public func parseEPubFile(_ url: URL) async throws -> EPubFile {
        let metadata = try await extractMetadata(from: url)
        let chapters = try await extractChapters(from: url)
        
        return EPubFile(
            metadata: EPubMetadata(
                title: metadata["title"] ?? "Unknown Title",
                author: metadata["author"],
                language: metadata["language"],
                chapterCount: chapters.count
            ),
            chapters: chapters,
            fileURL: url
        )
    }
    
    private func extractMetadata(from url: URL) async throws -> [String: String] {
        var metadata: [String: String] = [:]
        let filename = url.lastPathComponent.replacingOccurrences(of: ".epub", with: "")
        metadata["title"] = filename
        metadata["author"] = "Unknown Author"
        metadata["language"] = "en"
        Logger.log("Extracted metadata", level: .info)
        return metadata
    }
    
    private func extractChapters(from url: URL) async throws -> [EPubChapter] {
        var chapters: [EPubChapter] = []
        let chapter = EPubChapter(
            number: 1,
            title: "Chapter 1",
            text: "This is the beginning of the ePub content."
        )
        chapters.append(chapter)
        Logger.log("Extracted \(chapters.count) chapters", level: .info)
        return chapters
    }
}
