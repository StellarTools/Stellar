import Foundation

public protocol VersionProviding {
    
    /// Return all available remote versions.
    ///
    /// - Parameter includePreReleases: `true` to include pre-releases into the list.
    /// - Returns: remote releases
    func versions(includePreReleases: Bool) throws -> [RemoteVersion]
    
    /// Return release by tag name.
    ///
    /// - Parameter tagName: tag name.
    /// - Returns: remote version
    func versionByTag(_ tagName: String) throws -> RemoteVersion?
    
    /// Return the latest official release.
    ///
    /// - Returns: latest remote release.
    func latestVersion() throws -> RemoteVersion?
    
    func downloadPackage(type: RemoteVersion.AssetKind, ofRelease release: RemoteVersion, toURL: URL) throws

}

public enum VersionProviderErrors: Error {
    case cannotFoundRelease(String)
    case failedToIdentifyReleaseURL(RemoteVersion)
}

// MARK: - VersionProvider

public final class VersionProvider: VersionProviding {
        
    public let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func versions(includePreReleases: Bool = false) throws -> [RemoteVersion] {
        guard let latestReleases = try urlSession.githubApi(url: GitHubAPI.apiReleases,
                                                            decode: [RemoteVersion].self) else {
            return []
        }
        
        guard !includePreReleases else {
            return latestReleases
        }
        
        return latestReleases.filter {
            return !$0.prerelease
        }
    }
    
    public func versionByTag(_ tagName: String) throws -> RemoteVersion? {
        try urlSession.githubApi(url: GitHubAPI.apiReleaseTag.appendingPathComponent(tagName),
                                 decode: RemoteVersion.self)
    }
    
    public func latestVersion() throws -> RemoteVersion? {
        try urlSession.githubApi(url: GitHubAPI.apiLatestRelease,
                                 decode: RemoteVersion.self)
    }
    
    public func downloadPackage(type: RemoteVersion.AssetKind, ofRelease release: RemoteVersion, toURL: URL) throws {
        guard let url = release.assetURL(type: type) else {
            throw VersionProviderErrors.failedToIdentifyReleaseURL(release)
        }
        
        Logger().log("Downloading package at \(url.absoluteString)...")
        try urlSession.downloadFile(atURL: url, saveAtURL: toURL)
    }
    
}
