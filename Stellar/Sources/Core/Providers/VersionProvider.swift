import Foundation

protocol VersionProviding {
    
    func remoteVersions(includePreReleases: Bool) async throws -> [RemoteRelease]
    
}

// MARK: - VersionProvider

/// `VersionProvider` is used to query for remote versions of stellar available.
public final class VersionProvider: VersionProviding {
    
    // MARK: Public Properties
    
    public var apiProvider = APIProvider()

    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Functions
    
    /// Return the remote versions of stellar available on project's page.
    ///
    /// - Parameter includePreReleases: `true` to include pre-releases into the list.
    /// - Returns: list of remote releases.
    public func remoteVersions(includePreReleases: Bool = false) throws -> [RemoteRelease] {
        guard let latestReleases = try apiProvider.fetch(
            url: RemoteConstants.gitHubReleasesList,
            decode: [RemoteRelease].self
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
    
    /// Return the latest stable version available for install.
    ///
    /// - Returns: latest remove version.
    public func latestVersion() throws -> RemoteRelease? {
        try remoteVersions(includePreReleases: false).first
    }
    
}
