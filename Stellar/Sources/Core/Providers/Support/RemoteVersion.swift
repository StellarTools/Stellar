import Foundation

public struct RemoteVersion: Codable, Comparable, CustomStringConvertible {
    
    public let url: URL
    public let name: String
    public let prerelease: Bool
    public let assets: [Asset]
    public let tag_name: String
    
    public var version: SemVer {
        SemVer(stringLiteral: tag_name)
    }

    public struct Asset: Codable {
        let url: URL
        let name: String
    }
    
    public static func < (lhs: RemoteVersion, rhs: RemoteVersion) -> Bool {
        lhs.version < rhs.version
    }
    
    public static func == (lhs: RemoteVersion, rhs: RemoteVersion) -> Bool {
        lhs.version == rhs.version
    }
    
    public var description: String {
        version.description
    }
    
}
