import Foundation

// MARK: - String

extension String {
    
    /// The last component of the path.
    public var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }
    
}

// MARK: - URL

extension URL {
    
    /// Shortcut to create a glob patter to the specified url directory.
    ///
    /// - Parameter pattern: pattern to construct the glob.
    /// - Returns: contents at the path with the pattern set.
    func glob(_ pattern: String) -> [String] {
        Glob(pattern: appendingPathComponent(pattern).path).paths
    }
    
}

// MARK: - FileManager

extension FileManager {
    
    /// Creates a temporary directory and evaluates a closure with the directory path as an argument.
    ///
    ///
    /// - Parameters:
    ///   - path: when specified this path is used as root of the temporary directory.
    ///           If not the system temporary directory path is used.
    ///   - prefix: The prefix to the temporary file name.
    ///   - removeTreeOnDeinit: If enabled try to delete the whole directory tree otherwise remove only if its empty.
    ///   - closure: A closure to execute that receives the absolute path of the directory as an argument.
    ///              If `body` has a return value, that value is also used as the return value of the function.
    /// - Returns: `Result` specified
    public func withTemporaryDirectory<Result>(path: String? = nil,
                                               prefix: String = "TempDir",
                                               removeTreeOnDeinit: Bool = false ,
                                               _ closure: (URL) throws -> Result) throws -> Result {
    
        defer {
            if removeTreeOnDeinit {
                cleanup()
            }
        }
        
        // Construct path to the temporary directory.
        let folderName = "\(prefix)-\(UUID().uuidString)"
        let directoryPath = URL(fileURLWithPath: (path ?? NSTemporaryDirectory()), isDirectory: true).appendingPathComponent(folderName, isDirectory: true)
        try FileManager.default.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: true)
        
        func cleanup() {
            try? FileManager.default.removeItem(atPath: directoryPath.path)
        }
        
        return try closure(directoryPath)
    }

    
}
