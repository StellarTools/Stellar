import Foundation

/// Represent an installed version of the stellar environment.
public struct LocalRelease: Comparable, CustomStringConvertible {
    
    // MARK: - Public Properties
    
    /// Full path of the installed version.
    public let path: String
    
    /// Tag version as semserv format.
    public let version: SemVer
    
    // MARK: - Initialization
    
    /// Create a new instance starting from a version identifier.
    /// If version does not exists yet it will return `nil`.
    ///
    /// - Parameter version: version to locate.
    init?(version: SemVer) throws {
        let folderPath = try URLManager().systemVersionsLocation(version.description).path
        var isDirectory = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: folderPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            return nil
        }
        
        self.path = folderPath
        self.version = version
    }
    
    /// Create a new instance from a valid path with a version.
    /// If
    /// - Parameter path: proposed installation directory.
    init?(path: String) {
        guard let version = SemVer(path.lastPathComponent) else {
            return nil
        }
        
        self.path = path
        self.version = version
    }
    
    public static func < (lhs: LocalRelease, rhs: LocalRelease) -> Bool {
        lhs.version < rhs.version
    }
    
    public var description: String {
        version.description
    }
    
}