//  EnvService.swift

import Foundation
import AppKit

// MARK: - EnvServiceProtocol

protocol EnvServiceProtocol {
    
    /// Install StellarEnv tool.
    ///
    /// - Parameter version: version to install, `nil` to install latest remote version available.
    func install(version: String?) throws
    
}

// MARK: - EnvService

/// `EnvService` is used to update the `stellarenv` tool.
public final class EnvService: EnvServiceProtocol {
    
    // MARK: - Public Properties
    
    public let fileManager: FileManaging = FileManager.default
    public let releaseProvider: ReleaseProviding
        
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
        let taggedRelease = try releaseProvider.releaseWithTag(version)
        try install(release: taggedRelease)
    }
    
    private func installLatestVersion() throws {
        guard let latestRemoteVersion = try releaseProvider.latestRelease() else {
            Logger.info?.write("No remote version found.")
            return
        }
        
        try install(release: latestRemoteVersion)
    }
    
    private func install(release: RemoteRelease) throws {
        let installURL = URL(fileURLWithPath: FileConstants.envInstallDirectory)
            .appendingPathComponent(FileConstants.envBinName)

        Logger.info?.write("Downloading StellarEnv version \(release)")
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "com.stellarenv",
            autoRemove: false, { temporaryURL in
                // Download zip package
                let packageDestination = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvZipAsset)
                try releaseProvider.downloadAsset(type: .env, ofRelease: release, toURL: packageDestination)
                // NSWorkspace.shared.activateFileViewerSelecting([packageDestination])
                
                // Unzip
                Logger.debug?.write("Expanding the archive…")
                try Shell.unzip(fileURL: packageDestination,
                                name: RemoteConstants.stellarEnv,
                                destinationURL: temporaryURL)

                // Remove old version and replace with the new one
                Logger.info?.write("Installing at \(installURL.path)…")
                let envToolFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnv)
                try Shell.copyAndReplace(source: envToolFileURL, destination: installURL.path)
                
                Logger.info?.write("StellarEnv version \(release) installed")
            }
        )
    }
    
}
