import Foundation

protocol VersionsControlling: AnyObject {
    
    /// Return all installed versions of stellar.
    ///
    /// - Returns: versions available in `.stellar` folder.
    func versions() -> [InstalledVersion]
}

public struct InstalledVersion: Comparable, CustomStringConvertible {
    
    public let path: String
    public let version: Semver
    
    init?(path: String) {
        guard let version = Semver(path.lastPathComponent) else {
            return nil
        }
        
        self.path = path
        self.version = version
    }
    
    public static func < (lhs: InstalledVersion, rhs: InstalledVersion) -> Bool {
        lhs.version < rhs.version
    }
    
    public var description: String {
        version.description
    }
}

public final class VersionsManager: VersionsControlling {
    
    // MARK: - Initialization
    
    public init() {}
 
    // MARK: - Public Functions
    
    /// Return the list of installed versions.
    ///
    /// - Returns: installed versions ordered from oldest to newest.
    func versions() -> [InstalledVersion] {
        URLManager().environmentURL.glob("*").compactMap { InstalledVersion(path: $0) }.sorted()
    }
    
}
