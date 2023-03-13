//  RemoteRelease.swift

import Foundation

public struct RemoteRelease: Comparable, CustomStringConvertible {
    
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
    public let preRelease: Bool
    public let assets: [Asset]
    public let tagName: String
    
    public var version: SemVer {
        SemVer(stringLiteral: tagName)
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

extension RemoteRelease: Codable {
    
    enum CodingKeys: String, CodingKey {
        case url
        case name
        case preRelease = "prerelease"
        case assets
        case tagName = "tag_name"
    }
    
}
