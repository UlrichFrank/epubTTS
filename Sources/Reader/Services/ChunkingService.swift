import Foundation

/// Service for chunking text into speakable segments
public class ChunkingService {
    /// Words per minute for TTS (default 150 for average speech rate)
    private let wordsPerMinute: Int
    
    public init(wordsPerMinute: Int = 150) {
        self.wordsPerMinute = max(50, min(300, wordsPerMinute)) // Clamp between 50 and 300
    }
    
    /// Chunk text by sentences
    public func chunkBySentences(_ text: String) -> [TextChunk] {
        let sentences = splitBySentences(text)
        var chunks: [TextChunk] = []
        var currentIndex = 0
        
        for sentence in sentences {
            let startIndex = currentIndex
            let endIndex = currentIndex + sentence.count
            let duration = calculateDuration(for: sentence)
            
            let chunk = TextChunk(
                startIndex: startIndex,
                endIndex: endIndex,
                text: sentence,
                duration: duration
            )
            chunks.append(chunk)
            currentIndex = endIndex
        }
        
        return chunks
    }
    
    /// Chunk text by words
    public func chunkByWords(_ text: String) -> [TextChunk] {
        let words = text.split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
        var chunks: [TextChunk] = []
        var currentIndex = 0
        
        for word in words {
            let startIndex = currentIndex
            let endIndex = currentIndex + word.count
            let duration = calculateDuration(for: word)
            
            let chunk = TextChunk(
                startIndex: startIndex,
                endIndex: endIndex,
                text: word,
                duration: duration
            )
            chunks.append(chunk)
            currentIndex = endIndex + 1 // Account for space
        }
        
        return chunks
    }
    
    /// Chunk text by custom word count per chunk
    public func chunkByWordCount(_ text: String, wordsPerChunk: Int = 10) -> [TextChunk] {
        let words = text.split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
        var chunks: [TextChunk] = []
        var currentIndex = 0
        
        var i = 0
        while i < words.count {
            let chunkWords = words[i..<min(i + wordsPerChunk, words.count)]
            let chunkText = chunkWords.joined(separator: " ")
            let startIndex = currentIndex
            let endIndex = currentIndex + chunkText.count
            let duration = calculateDuration(for: chunkText)
            
            let chunk = TextChunk(
                startIndex: startIndex,
                endIndex: endIndex,
                text: chunkText,
                duration: duration
            )
            chunks.append(chunk)
            
            currentIndex = endIndex + 1 // Account for space
            i += wordsPerChunk
        }
        
        return chunks
    }
    
    /// Calculate estimated duration for text in seconds
    public func calculateDuration(for text: String) -> TimeInterval {
        let wordCount = text.split(separator: " ").count
        let minuteCount = Double(wordCount) / Double(wordsPerMinute)
        return minuteCount * 60.0
    }
    
    /// Get total duration for all chunks
    public func getTotalDuration(_ chunks: [TextChunk]) -> TimeInterval {
        chunks.map { $0.duration }.reduce(0, +)
    }
    
    /// Find chunk at specific playback time
    public func findChunkAtTime(_ chunks: [TextChunk], time: TimeInterval) -> TextChunk? {
        var cumulativeTime: TimeInterval = 0
        for chunk in chunks {
            let chunkEndTime = cumulativeTime + chunk.duration
            if time >= cumulativeTime && time < chunkEndTime {
                return chunk
            }
            cumulativeTime = chunkEndTime
        }
        return nil
    }
    
    /// Split text into sentences
    private func splitBySentences(_ text: String) -> [String] {
        let sentences = text
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        // Add punctuation back and preserve spacing
        return sentences.map { sentence in
            // Find the original position and add back the punctuation
            if let range = text.range(of: sentence) {
                let startIndex = text.index(range.lowerBound, offsetBy: sentence.count)
                if startIndex < text.endIndex && ".!?".contains(text[startIndex]) {
                    return sentence + String(text[startIndex])
                }
            }
            return sentence
        }
    }
}
