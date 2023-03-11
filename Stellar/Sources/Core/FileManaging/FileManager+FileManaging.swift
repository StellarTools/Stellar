//  FileManager+FileManaging.swift

import Foundation

extension FileManager: FileManaging {
    
    enum FileManagerError: Error {
        case cannotCreateFile(URL)
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

    public func createFile(at location: URL, content data: Data) throws {
        guard createFile(atPath: location.path, contents: data) else {
            throw FileManagerError.cannotCreateFile(location)
        }
    }

    public func createFolder(at location: URL) throws {
        guard !folderExists(at: location) else {
            throw FileManagerError.existingFolder(location)
        }
        try createDirectory(at: location, withIntermediateDirectories: true)
    }

    public func deleteFile(at location: URL) throws {
        guard fileExists(at: location) else {
            throw FileManagerError.missingFile(location)
        }
        try removeItem(at: location)
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
    
    public func copyFile(from location: URL, to destination: URL) throws {
        guard fileExists(atPath: location.path) else {
            return
        }
        
        if fileExists(atPath: destination.path) {
            try removeItem(atPath: destination.path)
        }
        
        try copyItem(atPath: location.path, toPath: destination.path)
    }
    
    /// Create a temporary directory and evaluates a closure with the directory path as an argument.
    ///
    ///
    /// - Parameters:
    ///   - path: when specified this path is used as root of the temporary directory.
    ///           If not the system temporary directory path is used.
    ///   - prefix: The prefix of the temporary directory.
    ///   - autoRemove: If true, it tries to delete the temporary directory after executing the closure.
    ///   - closure: A closure to execute that receives the absolute path of the directory as an argument.
    /// - Returns: The value returned by the closure.
    public func withTemporaryDirectory<Result>(path: String? = nil,
                                               prefix: String = "TempDir",
                                               autoRemove: Bool = true,
                                               _ closure: (URL) throws -> Result) throws -> Result {
        let folderName = "\(prefix)-\(UUID().uuidString)"
        let location = URL(fileURLWithPath: (path ?? NSTemporaryDirectory()), isDirectory: true).appendingPathComponent(folderName, isDirectory: true)
        try createDirectory(at: location, withIntermediateDirectories: true)
        
        let res = try closure(location)
        if autoRemove {
            try? removeItem(at: location)
        }
        return res
    }
    
}
