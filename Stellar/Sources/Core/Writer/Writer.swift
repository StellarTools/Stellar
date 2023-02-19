//  Writer.swift

import Foundation

final class Writer {
    
    enum WriterError: Equatable, Error {
        case existingFile(URL)
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
        try fileManager.createFile(at: location, content: Data(content.utf8))
    }
}
