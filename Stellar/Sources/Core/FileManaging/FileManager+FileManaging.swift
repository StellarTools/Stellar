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
    
    public func copyFile(from location: URL, to destination: URL) throws {
        guard fileExists(atPath: location.path) else {
            return
        }
        
        if fileExists(atPath: destination.path) {
            try removeItem(atPath: destination.path)
        }
        
        try moveItem(atPath: location.path, toPath: destination.path)
    }
    
    /// Creates a temporary directory and evaluates a closure with the directory path as an argument.
    ///
    ///
    /// - Parameters:
    ///   - path: when specified this path is used as root of the temporary directory.
    ///           If not the system temporary directory path is used.
    ///   - prefix: The prefix to the temporary file name.
    ///   - autoRemove: If enabled try to delete the whole directory tree otherwise remove only if its empty.
    ///   - closure: A closure to execute that receives the absolute path of the directory as an argument.
    ///              If `body` has a return value, that value is also used as the return value of the function.
    /// - Returns: `Result` specified
    public func withTemporaryDirectory<Result>(path: String? = nil,
                                               prefix: String = "TempDir",
                                               autoRemove: Bool = true ,
                                               _ closure: (URL) async throws -> Result) async throws -> Result {
        // Construct path to the temporary directory.
        let folderName = "\(prefix)-\(UUID().uuidString)"
        let directoryPath = URL(fileURLWithPath: (path ?? NSTemporaryDirectory()), isDirectory: true).appendingPathComponent(folderName, isDirectory: true)
        try FileManager.default.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: true)
        
        let res = try await closure(directoryPath)
        try? FileManager.default.removeItem(atPath: directoryPath.path)
        return res
    }
    
}
