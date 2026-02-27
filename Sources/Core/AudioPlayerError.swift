import Foundation

public enum AudioPlayerError: LocalizedError {
    case invalidFile(reason: String)
    case fileNotFound(path: String)
    case fileAccessDenied(path: String)
    case insufficientMemory(required: Int, available: Int)
    case failedToSynthesizeAudio(reason: String)
    case audioPlaybackFailed(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidFile(let reason):
            return "Unsupported file format: \(reason)"
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .fileAccessDenied(let path):
            return "Access denied to file: \(path)"
        case .insufficientMemory(let required, let available):
            return "Insufficient memory. Required: \(required)MB, Available: \(available)MB"
        case .failedToSynthesizeAudio(let reason):
            return "Failed to synthesize audio: \(reason)"
        case .audioPlaybackFailed(let reason):
            return "Audio playback failed: \(reason)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidFile:
            return "Please select a valid ePub file (.epub)"
        case .fileNotFound:
            return "The file may have been moved or deleted. Try importing again."
        case .fileAccessDenied:
            return "Please check file permissions or try selecting the file again."
        case .insufficientMemory:
            return "The file is too large. Try closing other apps or selecting a smaller file."
        case .failedToSynthesizeAudio:
            return "Try restarting the app or selecting a different ePub file."
        case .audioPlaybackFailed:
            return "Check your device's audio settings and try again."
        }
    }
}
