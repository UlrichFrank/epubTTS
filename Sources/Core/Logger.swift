import Foundation

public enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

public class Logger {
    public static func log(_ message: String, level: LogLevel = .info) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let formattedMessage = "[\(timestamp)] [\(level.rawValue)] \(message)"
        print(formattedMessage)
    }
}
