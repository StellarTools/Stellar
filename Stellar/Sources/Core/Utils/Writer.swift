//  Writer.swift

import Foundation

final class Writer {
    
    enum WriterError: Error {
        case fileExists(String)
    }
    
    func write(content: String, to location: URL) throws {
        var objcTrue: ObjCBool = false
        guard !FileManager.default.fileExists(atPath: location.path, isDirectory: &objcTrue) else {
            throw WriterError.fileExists(location.path)
        }
        
        let containingFolder = location.deletingLastPathComponent()
        try createFolderIfMissing(at: containingFolder)
        try content.write(to: location, atomically: true, encoding: .utf8)
    }
    
    func createFolderIfMissing(at location: URL) throws {
        var objcTrue: ObjCBool = true
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: location.path, isDirectory: &objcTrue) {
            try fileManager.createDirectory(atPath: location.path, withIntermediateDirectories: true)
        }
    }
}
