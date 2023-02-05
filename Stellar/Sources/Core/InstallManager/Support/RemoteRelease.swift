import Foundation

public struct RemoteRelease: Codable, Comparable {
    
    public let url: URL
    public let name: String
    public let prerelease: Bool
    public let assets: [Asset]
    public let tag_name: String

    public struct Asset: Codable {
        let url: URL
        let name: String
    }
    
    public static func < (lhs: RemoteRelease, rhs: RemoteRelease) -> Bool {
        SemVer(stringLiteral: lhs.tag_name) < SemVer(stringLiteral: rhs.tag_name)
    }
    
    public static func == (lhs: RemoteRelease, rhs: RemoteRelease) -> Bool {
        SemVer(stringLiteral: lhs.tag_name) == SemVer(stringLiteral: rhs.tag_name)
    }
    
}
