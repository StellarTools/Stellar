//  FileManager+FileManaging.swift

import Foundation

extension FileManager: FileManaging {
    
    enum FileManagerError: Error {
        case existingFolder(URL)
        case missingFile(URL)
        case missingFolder(URL)
    }
    
    public var currentLocation: URL {
        URL(fileURLWithPath: currentDirectoryPath)
    }
    
    public func fileExists(at location: URL) -> Bool {
        var objcTrue: ObjCBool = false
        return fileExists(atPath: location.path, isDirectory: &objcTrue)
    }
    
    public func folderExists(at location: URL) -> Bool {
        var objcTrue: ObjCBool = true
        return fileExists(atPath: location.path, isDirectory: &objcTrue)
    }
    
    public func createFolder(at location: URL) throws {
        guard !folderExists(at: location) else {
            throw FileManagerError.existingFolder(location)
        }
        try createDirectory(at: location, withIntermediateDirectories: true)
    }
    
    public func deleteFolder(at location: URL) throws {
        guard folderExists(at: location) else {
            throw FileManagerError.missingFolder(location)
        }
        try removeItem(at: location)
    }
    
    public func verifyFileExisting(at location: URL) throws {
        guard fileExists(at: location) else {
            throw FileManagerError.missingFile(location)
        }
    }
    
    public func verifyFolderExisting(at location: URL) throws {
        guard folderExists(at: location) else {
            throw FileManagerError.missingFolder(location)
        }
    }
    
    public func enumerator(at location: URL) -> FileManager.DirectoryEnumerator? {
        enumerator(at: location, includingPropertiesForKeys: [], options: [])
    }
}
