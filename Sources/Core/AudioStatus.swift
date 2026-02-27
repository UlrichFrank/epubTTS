import Foundation

public enum AudioStatus: Hashable {
    case idle
    case loading
    case playing
    case paused
    case finished
    case error(String)
    
    public var isPlaying: Bool {
        if case .playing = self { return true }
        return false
    }
    
    public var icon: String {
        switch self {
        case .idle, .paused:
            return "pause.circle.fill"
        case .loading:
            return "hourglass"
        case .playing:
            return "play.circle.fill"
        case .finished:
            return "checkmark.circle.fill"
        case .error:
            return "exclamationmark.circle.fill"
        }
    }
}
