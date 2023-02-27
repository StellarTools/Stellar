import Foundation
import AppKit
import ShellOut

public protocol CLIInstallerProtocol {
    
    
    /// Install a new version of the stellar's CLI tool.
    ///
    /// - Parameters:
    ///   - version: version to install, if `nil` the latest available version will be installed.
    ///   - preRelease: used when `version` is `nil` to also check pre-release versions.
    /// - Returns: installed URL
    @discardableResult
    func install(version: String?, preRelease: Bool) throws -> URL?
    
    
    /// Pin given [project at] location to a specified version of stellar.
    ///
    /// - Parameters:
    ///   - url: url of the source folder.
    ///   - version: version to pin.
    func pin(url: URL?, toVersion version: String) throws
    
}

// MARK: - CLIInstaller

/// `CLIInstaller` is used to install or pin a project to a specific version of stellar.
public final class CLIInstaller: CLIInstallerProtocol {

    // MARK: - Public Properties
    
    public var fileManager: FileManaging = FileManager.default
    public let releaseProvider: ReleaseProviding
    public let versionResolver: VersionResolving
    
    // MARK: - Private Properties

    private var urlManager = URLManager()

    // MARK: - Initialization
    
    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.releaseProvider = releaseProvider
        self.versionResolver = versionResolver
    }
    
    // MARK: - Public Functions

    public func pin(url: URL?, toVersion version: String) throws {
        let destinationURL = url ?? urlManager.currentWorkingDirectory()
        
        Logger().log("Generating \(FileConstants.versionsFile) file with version \(version)")
        let fileURL = destinationURL.appendingPathComponent(FileConstants.versionsFile)
        try "\(version)".write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )
        Logger().log("File generated at path \(fileURL.path)")
    }
    
    public func install(version: String?, preRelease: Bool = false) throws -> URL? {
        if let version { // Install specified version.
            return try install(version: version)
        }
        
        // Get latest version available.
        guard let latestVersion = try releaseProvider.availableReleases(preReleases: preRelease).first else {
            Logger().log("Failed to evaluate latest available version on remote")
            return nil
        }
        
        Logger().log("Latest \(preRelease ? "prerelease" : "stable") release found is \(latestVersion.tag_name)")
        return try install(version: latestVersion.tag_name)
    }
    
    public func latestInstalledVersion() throws -> LocalVersion? {
        try versionResolver.latestInstalledVersion()
    }
    
    // MARK: - Private Functions
    
    /// Install a specific version of stellar.
    ///
    /// - Parameter version: version to install.
    private func install(version: String) throws -> URL {
        guard let taggedRelease = try releaseProvider.releaseWithTag(version) else {
            Logger().log("Failed to get tagged release \(version)")
            throw ReleaseProviderErrors.cannotFoundRelease(version)
        }
        
        let installURL = try urlManager.systemVersionsLocation(version)
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "com.stellar",
            autoRemove: true, { temporaryURL in
                // Download the release zip file
                Logger().log("Downloading stellar v.\(version)...")
                let remoteFileURL = temporaryURL.appendingPathComponent(RemoteConstants.releaseZip)
                try releaseProvider.downloadAsset(type: .cli, ofRelease: taggedRelease, toURL: remoteFileURL)

                // Unzip the file
                try Shell.shared.unzip(fileURL: remoteFileURL, destinationURL: installURL)
                NSWorkspace.shared.activateFileViewerSelecting([installURL])
                
                Logger().log("Stellar version \(version) installed")
        })
        
        return installURL
    }
    
}
