import Foundation

@MainActor
public class FileService {
    public static let shared = FileService()
    
    private let MAX_FILE_SIZE = 200 * 1024 * 1024
    private let fileManager = FileManager.default
    
    public func importEPubFile(from sourceURL: URL) async throws -> EPubFile {
        guard fileManager.fileExists(atPath: sourceURL.path) else {
            throw AudioPlayerError.fileNotFound(path: sourceURL.path)
        }
        
        let attributes = try fileManager.attributesOfItem(atPath: sourceURL.path)
        let fileSize = attributes[.size] as? Int ?? 0
        guard fileSize < MAX_FILE_SIZE else {
            let sizeInMB = fileSize / (1024 * 1024)
            throw AudioPlayerError.insufficientMemory(required: sizeInMB, available: MAX_FILE_SIZE / (1024 * 1024))
        }
        
        guard isValidEPub(sourceURL) else {
            throw AudioPlayerError.invalidFile(reason: "Missing required ePub structure")
        }
        
        let appDocumentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = sourceURL.lastPathComponent
        let destinationURL = appDocumentsURL.appendingPathComponent(fileName)
        
        try? fileManager.removeItem(at: destinationURL)
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
        
        Logger.log("File imported: \(fileName)", level: .info)
        let epubFile = try await EPubService.shared.parseEPubFile(destinationURL)
        return epubFile
    }
    
    private func isValidEPub(_ url: URL) -> Bool {
        return url.pathExtension.lowercased() == "epub"
    }
}
