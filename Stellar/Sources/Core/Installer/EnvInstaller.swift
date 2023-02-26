import Foundation
import ShellOut
import AppKit

// MARK: - EnvInstallerProtocol

protocol EnvInstallerProtocol {

    func install(version: String) throws
    func install() throws
    
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
    public func install() throws {
        guard let latestRemoteVersion = try versionProvider.latestVersion() else {
            Logger().log("No remote version found")
            return
        }
        
        try install(version: latestRemoteVersion.version.description)
    }
    
    /// Install specified version of the `stellarenv`.
    ///
    /// - Parameter version: version to install.
    public func install(version: String) throws {
        let installationPath = FileConstants.envInstallDirectory

        Logger().log("Downloading StellarEnv version \(version)")
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "com.stellarenv",
            autoRemove: true, { temporaryURL in
                // Download release
                let packageDestination = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvPackage)
                //try Shell.shared.file(url: packageURL, at: packageDestination)
                
                try versionProvider.downloadEnvPackage(version: version, fileURL: packageDestination)
                NSWorkspace.shared.activateFileViewerSelecting([packageDestination])
                
                // Unzip the bundle
                Logger().log("Expading the archive…")
                try Shell.shared.unzip(fileURL: packageDestination, name: RemoteConstants.stellarEnvCLI, destinationURL: temporaryURL)

                // Remove old version and replace with the new one
                Logger().log("Installing…")
                let cliToolFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvCLI)
                try Shell.shared.copyAndReplace(source: cliToolFileURL, destination: installationPath)
                
                Logger().log("StellarEnv version \(version) installed")
            }
        )
    }
    
}
