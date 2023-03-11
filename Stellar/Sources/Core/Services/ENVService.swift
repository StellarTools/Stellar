import Foundation
import ShellOut
import AppKit

// MARK: - ENVServiceProtocol

protocol ENVServiceProtocol {
    
    /// Install StellarEnv tool.
    ///
    /// - Parameter version: version to install, `nil` to install latest remote version available.
    func install(version: String?) throws
    
}

// MARK: - ENVService

/// `ENVService` is used to update the `stellarenv` tool.
public final class ENVService: ENVServiceProtocol {
    
    // MARK: - Public Properties
    
    public let fileManager: FileManaging = FileManager.default
    public let releaseProvider: ReleaseProviding
    
    private let logger = Logger()
    
    // MARK: - Initialization

    public init(releaseProvider: ReleaseProviding = ReleaseProvider()) {
        self.releaseProvider = releaseProvider
    }
    
    // MARK: - Public Functions
    
    /// Install latest stable version of the `stellarenv`.
    public func install(version: String? = nil) throws {
        if let version {
            try install(version: version)
        } else {
            try installLatestVersion()
        }
    }
    
    // MARK: - Private Functions
    
    private func install(version: String) throws {
        guard let taggedRelease = try releaseProvider.releaseWithTag(version) else {
            logger.log("Tagged release \(version) not found.")
            return
        }
        
        try install(release: taggedRelease)
    }
    
    private func installLatestVersion() throws {
        guard let latestRemoteVersion = try releaseProvider.latestRelease() else {
            logger.log("No remote version found.")
            return
        }
        
        try install(release: latestRemoteVersion)
    }
    
    private func install(release: RemoteRelease) throws {
        let installURL = URL(fileURLWithPath: FileConstants.envInstallDirectory)
            .appendingPathComponent(FileConstants.envBinName)

        logger.log("Downloading StellarEnv version \(release)")
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "com.stellarenv",
            autoRemove: false, { temporaryURL in
                // Download zip package
                let packageDestination = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvZipAsset)
                try releaseProvider.downloadAsset(type: .env, ofRelease: release, toURL: packageDestination)
                // NSWorkspace.shared.activateFileViewerSelecting([packageDestination])
                
                // Unzip
                logger.log("Expading the archive…")
                try Shell.shared.unzip(fileURL: packageDestination, name: RemoteConstants.stellarEnvCLI, destinationURL: temporaryURL)

                // Remove old version and replace with the new one
                logger.log("Installing at \(installURL.path)…")
                let cliToolFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvCLI)
                try Shell.shared.copyAndReplace(source: cliToolFileURL, destination: installURL.path)
                
                logger.log("StellarEnv version \(release) installed")
            }
        )
    }
    
}
