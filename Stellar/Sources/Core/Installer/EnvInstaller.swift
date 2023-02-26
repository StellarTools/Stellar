import Foundation
import ShellOut
import AppKit

// MARK: - EnvInstallerProtocol

protocol EnvInstallerProtocol {
    
    /// Install stellar Env tool.
    ///
    /// - Parameter version: version to install, `nil` to install latest remote version available.
    func install(version: String?) throws
    
}

// MARK: - EnvInstaller

/// `EnvInstaller` is used to update the `stellarenv` tool.
public final class EnvInstaller: EnvInstallerProtocol {
    
    // MARK: - Public Properties
    
    public var fileManager: FileManaging = FileManager.default
    public var versionProvider: VersionProviding
    
    // MARK: - Initialization

    public init(versionProvider: VersionProviding = VersionProvider()) {
        self.versionProvider = versionProvider
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
    
    private func installLatestVersion() throws {
        guard let latestRemoteVersion = try versionProvider.latestVersion() else {
            Logger().log("No remote version found")
            return
        }
        
        try install(version: latestRemoteVersion.version.description)
    }
    
    private func install(version: String) throws {
        let installURL = URL(fileURLWithPath: FileConstants.envInstallDirectory)
            .appendingPathComponent(FileConstants.envBinName)

        Logger().log("Downloading StellarEnv version \(version)")
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "com.stellarenv",
            autoRemove: true, { temporaryURL in
                // Download zip package
                let packageDestination = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvPackage)
                try versionProvider.downloadEnvPackage(version: version, fileURL: packageDestination)
                // NSWorkspace.shared.activateFileViewerSelecting([packageDestination])
                
                // Unzip
                Logger().log("Expading the archive…")
                try Shell.shared.unzip(fileURL: packageDestination, name: RemoteConstants.stellarEnvCLI, destinationURL: temporaryURL)

                // Remove old version and replace with the new one
                Logger().log("Installing in \(installURL.path)…")
                let cliToolFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvCLI)
                try Shell.shared.copyAndReplace(source: cliToolFileURL, destination: installURL.path)
                
                Logger().log("StellarEnv version \(version) installed")
            }
        )
    }
    
}
