import Foundation

protocol VersionProviding {
    
    func remoteVersions(includePreReleases: Bool) async throws -> [RemoteRelease]
    
}


public final class VersionProvider: VersionProviding {
    
    private let networkManager = NetworkManager()

    public init() {}
    
    public func remoteVersions(includePreReleases: Bool = false) throws -> [RemoteRelease] {
        guard let latestReleases = try networkManager.httpRequest(
            model: [RemoteRelease].self,
            url: RemoteConstants.gitHubReleasesList
        ) else {
            return []
        }
        
        guard !includePreReleases else {
            return latestReleases
        }
        
        return latestReleases.filter {
            return !$0.prerelease
        }
    }
    
    public func latestVersion() throws -> RemoteRelease? {
        try remoteVersions(includePreReleases: false).first
    }
    
}
