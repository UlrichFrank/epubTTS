import Foundation

public struct EPubFile: Identifiable, Codable {
    public let id: UUID
    public let metadata: EPubMetadata
    public let chapters: [EPubChapter]
    public let fileURL: URL?
    
    public init(metadata: EPubMetadata, chapters: [EPubChapter], fileURL: URL? = nil) {
        self.id = UUID()
        self.metadata = metadata
        self.chapters = chapters
        self.fileURL = fileURL
    }
}
