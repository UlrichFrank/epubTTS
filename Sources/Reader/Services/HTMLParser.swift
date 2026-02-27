import Foundation

/// HTML parser for extracting text from ePub XHTML content
public class HTMLParser {
    /// Parse HTML string and extract plain text
    public static func parseText(_ html: String) -> String {
        let text = stripHTML(html)
        return text
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Remove HTML tags while preserving structure
    private static func stripHTML(_ html: String) -> String {
        var result = ""
        var skipTag = false
        var currentCharacter = ""
        
        for char in html {
            if char == "<" {
                skipTag = true
                if !currentCharacter.isEmpty {
                    result += currentCharacter
                }
                currentCharacter = ""
            } else if char == ">" {
                skipTag = false
                // Add space after closing tags (like </p>, </div>)
                if currentCharacter.lowercased().hasPrefix("/") || 
                   currentCharacter.lowercased() == "br" {
                    result += "\n"
                }
                currentCharacter = ""
            } else if !skipTag {
                currentCharacter.append(char)
            }
        }
        
        if !currentCharacter.isEmpty {
            result += currentCharacter
        }
        
        // Clean up multiple newlines
        return result
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }
    
    /// Extract text with basic formatting information
    public static func parseWithFormatting(_ html: String) -> [(text: String, bold: Bool, italic: Bool)] {
        var result: [(String, Bool, Bool)] = []
        var currentText = ""
        var isBold = false
        var isItalic = false
        var skipTag = false
        var tagBuffer = ""
        
        for char in html {
            if char == "<" {
                skipTag = true
                if !currentText.isEmpty {
                    result.append((currentText, isBold, isItalic))
                    currentText = ""
                }
            } else if char == ">" {
                skipTag = false
                let tag = tagBuffer.lowercased()
                
                if tag == "b" || tag == "strong" {
                    isBold = true
                } else if tag == "/b" || tag == "/strong" {
                    isBold = false
                } else if tag == "i" || tag == "em" {
                    isItalic = true
                } else if tag == "/i" || tag == "/em" {
                    isItalic = false
                } else if tag.hasPrefix("/") || tag == "br" {
                    if !currentText.isEmpty {
                        result.append((currentText, isBold, isItalic))
                        currentText = ""
                    }
                    result.append(("\n", isBold, isItalic))
                }
                tagBuffer = ""
            } else if skipTag {
                tagBuffer.append(char)
            } else {
                currentText.append(char)
            }
        }
        
        if !currentText.isEmpty {
            result.append((currentText, isBold, isItalic))
        }
        
        return result.filter { !$0.0.trimmingCharacters(in: .whitespaces).isEmpty || $0.0 == "\n" }
    }
    
    /// Get text content length (for position tracking)
    public static func getTextLength(_ html: String) -> Int {
        parseText(html).count
    }
    
    /// Extract first N characters of text from HTML
    public static func getTextPrefix(_ html: String, maxLength: Int) -> String {
        let text = parseText(html)
        return String(text.prefix(maxLength))
    }
}
