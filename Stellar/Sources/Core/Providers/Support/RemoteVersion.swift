import Foundation

public struct RemoteVersion: Codable, Comparable, CustomStringConvertible {
    
    public enum AssetKind {
        case env
        case cli
        
        var name: String {
            switch self {
            case .env: return "StellarEnv.zip"
            case .cli: return "StellarCLI.zip"
            }
        }
    }
    
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
    
    public func assetURL(type: AssetKind) -> URL? {
        assets.first(where: { $0.name == type.name })?.url
    }
    
}
