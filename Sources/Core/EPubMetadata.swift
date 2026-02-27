import Foundation

public struct EPubMetadata: Codable {
    public let title: String
    public let author: String?
    public let language: String?
    public let chapterCount: Int
}
