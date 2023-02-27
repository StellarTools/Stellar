import Foundation

public protocol ReleaseProviding {
    
    /// Return all available remote versions.
    ///
    /// - Parameter preReleases: `true` to include pre-releases into the list.
    /// - Returns: remote releases
    func availableReleases(preReleases: Bool) throws -> [RemoteRelease]
    
    /// Return release by tag name.
    ///
    /// - Parameter tagName: tag name.
    /// - Returns: remote version
    func releaseWithTag(_ tagName: String) throws -> RemoteRelease?
    
    /// Return the latest official release.
    ///
    /// - Returns: latest remote release.
    func latestRelease() throws -> RemoteRelease?
    
    /// Download asset from project repository.
    ///
    /// - Parameters:
    ///   - type: type of asset to download.
    ///   - release: target release.
    ///   - toURL: destination file url.
    func downloadAsset(type: RemoteRelease.AssetKind, ofRelease release: RemoteRelease, toURL: URL) throws

}

// MARK: - ReleaseProviderErrors

public enum ReleaseProviderErrors: Error {
    case releaseNotAvailable(String)
    case releaseURLNotAvailable(RemoteRelease)
}

// MARK: - ReleaseProvider

public final class ReleaseProvider: ReleaseProviding {
        
    public let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func availableReleases(preReleases: Bool = false) throws -> [RemoteRelease] {
        guard let latestReleases = try urlSession.gitHubAPI(url: GitHubAPI.apiReleases,
                                                            decode: [RemoteRelease].self) else {
            return []
        }
        
        guard !preReleases else {
            return latestReleases
        }
        
        return latestReleases.filter {
            return !$0.prerelease
        }
    }
    
    public func releaseWithTag(_ tagName: String) throws -> RemoteRelease? {
        try urlSession.gitHubAPI(url: GitHubAPI.apiReleaseTag.appendingPathComponent(tagName),
                                 decode: RemoteRelease.self)
    }
    
    public func latestRelease() throws -> RemoteRelease? {
        try urlSession.gitHubAPI(url: GitHubAPI.apiLatestRelease,
                                 decode: RemoteRelease.self)
    }
    
    public func downloadAsset(type: RemoteRelease.AssetKind, ofRelease release: RemoteRelease, toURL: URL) throws {
        guard let url = release.assetURL(type: type) else {
            throw ReleaseProviderErrors.releaseURLNotAvailable(release)
        }
        
        Logger().log("Downloading package \(type.name) at \(url.absoluteString)...")
        try urlSession.downloadFile(atURL: url, saveAtURL: toURL)
    }
    
}
