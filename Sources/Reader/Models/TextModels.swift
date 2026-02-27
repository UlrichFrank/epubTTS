import Foundation

/// Represents a chunk of text that can be spoken and highlighted
public struct TextChunk: Identifiable, Codable {
    public let id: UUID
    public let startIndex: Int
    public let endIndex: Int
    public let text: String
    public let duration: TimeInterval
    
    public init(
        id: UUID = UUID(),
        startIndex: Int,
        endIndex: Int,
        text: String,
        duration: TimeInterval
    ) {
        self.id = id
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.text = text
        self.duration = duration
    }
    
    /// Length of text in characters
    public var length: Int {
        text.count
    }
    
    /// End time of this chunk (cumulative duration)
    public var endTime: TimeInterval {
        duration
    }
}

/// Highlight color options
public enum HighlightColor: String, Codable {
    case yellow
    case orange
    case pink
    case purple
    case blue
    case green
    
    public var displayName: String {
        switch self {
        case .yellow: return "Yellow"
        case .orange: return "Orange"
        case .pink: return "Pink"
        case .purple: return "Purple"
        case .blue: return "Blue"
        case .green: return "Green"
        }
    }
}

/// User highlight on a text range
public struct Highlight: Identifiable, Codable {
    public let id: UUID
    public let bookId: String
    public let chapterIndex: Int
    public let startIndex: Int
    public let endIndex: Int
    public let color: HighlightColor
    public let timestamp: Date
    
    public init(
        id: UUID = UUID(),
        bookId: String,
        chapterIndex: Int,
        startIndex: Int,
        endIndex: Int,
        color: HighlightColor = .yellow,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.bookId = bookId
        self.chapterIndex = chapterIndex
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.color = color
        self.timestamp = timestamp
    }
}

/// Bookmark for saving reading position
public struct Bookmark: Identifiable, Codable {
    public let id: UUID
    public let bookId: String
    public let chapterIndex: Int
    public let position: TimeInterval
    public let timestamp: Date
    public let note: String?
    
    public init(
        id: UUID = UUID(),
        bookId: String,
        chapterIndex: Int,
        position: TimeInterval,
        timestamp: Date = Date(),
        note: String? = nil
    ) {
        self.id = id
        self.bookId = bookId
        self.chapterIndex = chapterIndex
        self.position = position
        self.timestamp = timestamp
        self.note = note
    }
}
