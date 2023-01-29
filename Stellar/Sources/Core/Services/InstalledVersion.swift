import Foundation

/// Represent an installed version of the stellar environment.
public struct InstalledVersion: Comparable, CustomStringConvertible {
    
    // MARK: - Public Properties
    
    /// Full path of the installed version.
    public let path: String
    
    /// Tag version as semserv format.
    public let version: Semver
    
    // MARK: - Initialization
    
    /// Create a new instance starting from a version identifier.
    /// If version does not exists yet it will return `nil`.
    ///
    /// - Parameter version: version to locate.
    init?(version: Semver) {
        let folderPath = URLManager().environmentURL.appendingPathComponent(version.description).path
        var isDirectory = ObjCBool(false)
        guard InstalledVersion.validateInstalledVersion(path: folderPath),
              FileManager.default.fileExists(atPath: folderPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            return nil
        }
        
        self.path = folderPath
        self.version = version
    }
    
    /// Create a new instance from a valid path with a version.
    /// If
    /// - Parameter path: proposed installation directory.
    init?(path: String) {
        guard InstalledVersion.validateInstalledVersion(path: path),
            let version = Semver(path.lastPathComponent) else {
            return nil
        }
        
        self.path = path
        self.version = version
    }
    
    /// Perform check on a directory with a version of the stellar in order
    /// to validate the integrity.
    ///
    /// - Parameter path: path of the directory.
    /// - Returns: `true` if valid.
    private static func validateInstalledVersion(path: String) -> Bool {
        // TODO: Should be implemented.
        true
    }
    
    public static func < (lhs: InstalledVersion, rhs: InstalledVersion) -> Bool {
        lhs.version < rhs.version
    }
    
    public var description: String {
        version.description
    }
    
}
