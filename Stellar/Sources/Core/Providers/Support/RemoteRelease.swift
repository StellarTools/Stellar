import Foundation

public struct RemoteRelease: Codable, Comparable, CustomStringConvertible {
    
    public enum AssetKind {
        case cli
        case env
        
        var name: String {
            switch self {
            case .cli: return RemoteConstants.stellarCLIZipAsset
            case .env: return RemoteConstants.stellarEnvZipAsset
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
    
    public static func < (lhs: RemoteRelease, rhs: RemoteRelease) -> Bool {
        lhs.version < rhs.version
    }
    
    public static func == (lhs: RemoteRelease, rhs: RemoteRelease) -> Bool {
        lhs.version == rhs.version
    }
    
    public var description: String {
        version.description
    }
    
    public func assetURL(type: AssetKind) -> URL? {
        assets.first(where: { $0.name == type.name })?.url
    }
    
}
