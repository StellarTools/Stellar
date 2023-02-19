import Foundation
import ShellOut
import AppKit

// MARK: - EnvInstalling

protocol EnvInstalling {

    func install(version: String) throws
    func install() throws
    
}

// MARK: - EnvInstaller

public final class EnvInstaller: EnvInstalling {
    
    // MARK: - Public Properties
    
    /// File manager to use.
    public var fileManager: FileManaging = FileManager.default
    
    /// Provider for remote versions.
    public var versionProvider = VersionProvider()

    // MARK: - Initialization

    public init() { }
    
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
        let packageURL = RemoteConstants.releasesURL(forVersion: version, assetsName: RemoteConstants.stellarEnvPackage)
        
        // TODO: It does not work on my machine
        // let installationPath = try System.shared.which("tuist")
        let installationPath = "/usr/local/bin/tuist"

        Logger().log("Downloading StellarEnv version \(version)")
        
        try fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "stellarenv_installation",
            autoRemove: true, { temporaryURL in
                // Download release
                let packageDestination = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvPackage)
                try System.shared.file(url: packageURL, at: packageDestination)
                //NSWorkspace.shared.activateFileViewerSelecting([downloadFileURL])
                
                // Unzip the bundle
                Logger().log("Expading the archive…")
                try System.shared.unzip(fileURL: packageDestination, name: RemoteConstants.stellarEnvCLI, destinationURL: temporaryURL)

                // Remove old version and replace with the new one
                Logger().log("Installing…")
                let cliToolFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvCLI)
                try System.shared.copyAndReplace(source: cliToolFileURL, destination: installationPath)
                
                Logger().log("StellarEnv version \(version) installed")
            }
        )
    }
    
}
