import Foundation

public protocol VersionProviding {
    
    /// Return all available remote versions.
    ///
    /// - Parameter includePreReleases: `true` to include pre-releases into the list.
    /// - Returns: remote releases
    func versions(includePreReleases: Bool) throws -> [RemoteVersion]
    
    /// Return the latest official release.
    ///
    /// - Returns: latest remote release.
    func latestVersion() throws -> RemoteVersion?
    
    /// Download the stellar ENV package and put at given location.
    ///
    /// - Parameters:
    ///   - version: version to download.
    ///   - fileURL: destination file location
    func downloadEnvPackage(version: String, fileURL: URL) throws
    
    /// Download the stellar CLI package and put at given location.
    ///
    /// - Parameters:
    ///   - version: version to download
    ///   - fileURL: destination file location
    func downloadCLIPackage(version: String, fileURL: URL) throws

}

// MARK: - VersionProvider

public final class VersionProvider: VersionProviding {
        
    private var urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func versions(includePreReleases: Bool = false) throws -> [RemoteVersion] {
        guard let latestReleases = try urlSession.githubApi(url: RemoteConstants.gitHubReleasesList, decode: [RemoteVersion].self) else {
            return []
        }
        
        guard !includePreReleases else {
            return latestReleases
        }
        
        return latestReleases.filter {
            return !$0.prerelease
        }
    }
    
    public func latestVersion() throws -> RemoteVersion? {
        try versions(includePreReleases: false).first
    }
    
    public func downloadEnvPackage(version: String, fileURL: URL) throws {
        let envPackageURL = RemoteConstants.releasesURL(forVersion: version, assetsName: RemoteConstants.stellarEnvPackage)
        try urlSession.downloadFile(atURL: envPackageURL, saveAtURL: fileURL)
    }
    
    public func downloadCLIPackage(version: String, fileURL: URL) throws {
        let releasesURL = RemoteConstants.releasesURL(forVersion: version, assetsName: RemoteConstants.stellarPackage)
        try urlSession.downloadFile(atURL: releasesURL, saveAtURL: fileURL)
    }
    
}
