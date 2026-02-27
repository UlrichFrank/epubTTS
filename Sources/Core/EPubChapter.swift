import Foundation

public struct EPubChapter: Identifiable, Codable {
    public let id: UUID
    public let number: Int
    public let title: String
    public let text: String
    
    public init(number: Int, title: String, text: String) {
        self.id = UUID()
        self.number = number
        self.title = title
        self.text = text
    }
}
