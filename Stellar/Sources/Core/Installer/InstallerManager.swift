import Foundation
import AppKit
import ShellOut

public protocol InstallManaging {
    
    func installedVersions() throws -> [LocalRelease]
    func install(version: String?, preRelease: Bool) throws
    func pin(url: URL?, toVersion version: String) throws
    
}

public final class InstallerManager: InstallManaging {

    // MARK: - Public Properties
    
    public let fileManager: FileManaging = FileManager.default
    public let networkManager = NetworkManager()
    public let versionProvider = VersionProvider()
    
    // MARK: - Private Properties

    private var urlManager = URLManager()

    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Functions
    
    /// Return the list of installed versions.
    ///
    /// - Returns: list of `LocalRelease` instances.
    public func installedVersions() throws -> [LocalRelease] {
        try urlManager.systemVersionsLocation().glob("*").compactMap {
            LocalRelease(path: $0)
        }.sorted()
    }
    
    /// Pin given [project at] location to a specified version of stellar.
    ///
    /// - Parameters:
    ///   - url: url of the source folder.
    ///   - version: version to pin.
    public func pin(url: URL?, toVersion version: String) throws {
        let destinationURL = url ?? urlManager.currentLocation()
        
        Logger().log("Generating \(FileConstants.versionsFile) file with version \(version)")
        let fileURL = destinationURL.appendingPathComponent(FileConstants.versionsFile)
        try "\(version)".write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )
        Logger().log("File generated at path \(fileURL.path)")
    }
    
    /// Install a new version of stellar.
    ///
    /// - Parameters:
    ///   - version: version to install, if `nil` the latest available version will be installed.
    ///   - preRelease: used when `version` is `nil` to also check pre-release versions.
    public func install(version: String?, preRelease: Bool = false) throws {
        if let version { // Install specified version.
            try install(version: version)
            return
        }
        
        // Get latest version available.
        guard let latestVersion = try versionProvider.remoteVersions(includePreReleases: preRelease).first else {
            Logger().log("Failed to evaluate latest available version on remote")
            return
        }
        
        Logger().log("Latest \(preRelease ? "prerelease" : "stable") release found is \(latestVersion.tag_name)")
        try install(version: latestVersion.tag_name)
    }
    
    // MARK: - Private Functions
    
    /// Install a specific version of stellar.
    ///
    /// - Parameter version: version to install.
    private func install(version: String) throws {
        let releasesURL = RemoteConstants.releasesURL(forVersion: version, assetsName: RemoteConstants.stellarPackage)
        let installURL = try urlManager.systemVersionsLocation(version)
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "installation",
            autoRemove: true, { temporaryURL in
            
                // Download the release zip file
                Logger().log("Downloading stellar v.\(version)...")
                let remoteFileURL = temporaryURL.appendingPathComponent(RemoteConstants.releaseZip)
                try networkManager.getFile(atURL: releasesURL, saveAtURL: remoteFileURL)

                // Unzip the file
                try shellOut(to: "unzip", arguments: ["-q", remoteFileURL.path, "-d", installURL.path])
                // NSWorkspace.shared.activateFileViewerSelecting([installURL])
                
                Logger().log("Stellar version \(version) installed")
        })
    }
    
}
