import Foundation

/// CSS style information
public struct StyleInfo {
    public let fontSize: Int?
    public let fontWeight: Int?
    public let textAlign: TextAlignment?
    public let isItalic: Bool
    public let isBold: Bool
    
    public init(
        fontSize: Int? = nil,
        fontWeight: Int? = nil,
        textAlign: TextAlignment? = nil,
        isItalic: Bool = false,
        isBold: Bool = false
    ) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.textAlign = textAlign
        self.isItalic = isItalic
        self.isBold = isBold
    }
}

public enum TextAlignment: String {
    case left
    case center
    case right
    case justify
}

/// CSS parser for extracting styling information
public class CSSParser {
    /// Parse inline CSS style string
    public static func parseInlineStyle(_ styleString: String) -> StyleInfo {
        var fontSize: Int? = nil
        var fontWeight: Int? = nil
        var textAlign: TextAlignment? = nil
        var isItalic = false
        var isBold = false
        
        let properties = styleString.split(separator: ";").map { String($0).trimmingCharacters(in: .whitespaces) }
        
        for property in properties {
            let parts = property.split(separator: ":", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else { continue }
            
            let key = parts[0].lowercased()
            let value = parts[1].lowercased()
            
            switch key {
            case "font-size":
                if let size = extractPixelValue(value) {
                    fontSize = size
                }
            case "font-weight":
                if let weight = extractFontWeight(value) {
                    fontWeight = weight
                    isBold = weight >= 600
                }
            case "text-align":
                textAlign = TextAlignment(rawValue: value)
            case "font-style":
                if value.contains("italic") {
                    isItalic = true
                }
            case "font-family":
                // Note: Font family not stored currently
                break
            default:
                break
            }
        }
        
        return StyleInfo(
            fontSize: fontSize,
            fontWeight: fontWeight,
            textAlign: textAlign,
            isItalic: isItalic,
            isBold: isBold
        )
    }
    
    /// Extract pixel value from CSS value string (e.g., "16px" -> 16)
    private static func extractPixelValue(_ value: String) -> Int? {
        let numberStr = value.replacingOccurrences(of: "px", with: "").trimmingCharacters(in: .whitespaces)
        return Int(numberStr)
    }
    
    /// Extract font weight from CSS value (e.g., "bold" -> 700, "400" -> 400)
    private static func extractFontWeight(_ value: String) -> Int? {
        switch value {
        case "normal": return 400
        case "bold": return 700
        case "lighter": return 300
        case "bolder": return 900
        default:
            // Try to parse as number
            if let weight = Int(value.trimmingCharacters(in: .whitespaces)) {
                return weight
            }
            return nil
        }
    }
    
    /// Get default font size for HTML element
    public static func getDefaultFontSize(for tag: String) -> Int {
        let lowercaseTag = tag.lowercased()
        switch lowercaseTag {
        case "h1": return 32
        case "h2": return 28
        case "h3": return 24
        case "h4": return 20
        case "h5": return 18
        case "h6": return 16
        case "p", "div", "span": return 16
        case "small": return 12
        default: return 16
        }
    }
    
    /// Get default font weight for HTML element
    public static func getDefaultFontWeight(for tag: String) -> Int {
        let lowercaseTag = tag.lowercased()
        if lowercaseTag.hasPrefix("h") {
            return 700 // Bold headers
        }
        return 400 // Normal weight
    }
}
