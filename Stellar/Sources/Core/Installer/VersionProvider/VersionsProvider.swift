import Foundation

protocol VersionProviding {
    
    func remoteVersions(includePreReleases: Bool) async throws -> [RemoteRelease]
    
}


public final class VersionProvider: VersionProviding {
    
    private let networkManager = NetworkManager()

    public init() {}
    
    public func remoteVersions(includePreReleases: Bool = false) async throws -> [RemoteRelease] {
        guard let latestReleases = try await networkManager.jsonRequest(
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
    
    public func latestVersion() async throws -> RemoteRelease? {
        try await remoteVersions(includePreReleases: false).first
    }
    
}
