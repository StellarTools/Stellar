//  Writer.swift

import Foundation

final class Writer {
    
    enum WriterError: Error {
        case existingFile(URL)
        case existingFolder(URL)
    }
    
    private let fileManager: FileManaging
    
    init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func write(content: String, to location: URL) throws {
        guard !fileManager.fileExists(at: location) else {
            throw WriterError.existingFile(location)
        }
        
        let containingFolder = location.deletingLastPathComponent()
        try? fileManager.createFolder(at: containingFolder)
        try content.write(to: location, atomically: true, encoding: .utf8)
    }
}
