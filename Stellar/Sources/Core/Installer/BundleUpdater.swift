import Foundation

protocol BundleUpdaterProtocol: AnyObject {
    
    func update() async throws
    
}

// MARK: - BundleUpdater

/// `BundleUpdater` is used to update both the `stellar` and `stellarenv` tools.
public final class BundleUpdater: BundleUpdaterProtocol {
    
    // MARK: - Public Properties
    
    public var versionProvider = VersionProvider()
    public var installManager = CLIInstaller()
    public var envInstaller = EnvInstaller()
    
    // MARK: - Initialization
    
    public init() { }
    
    // MARK: - Public Functions
    
    /// Update `stellarenv` installation by obtaining the latest stable version available.
    public func update() throws {
        guard let latestRemoteVersion = try versionProvider.latestVersion() else {
            Logger().log("No remote version found")
            return
        }
        
        if let latestLocalVersion = try installManager.installedVersions().first {
            guard latestRemoteVersion.version > latestLocalVersion.version else {
                Logger().log("There are not updates available")
                return
            }
            
            Logger().log("Installing new version available \(latestRemoteVersion)")
        } else {
            Logger().log("No local version available. Installing latest version \(latestRemoteVersion)")
        }
        
        // Install version of stellar
        try installManager.install(version: latestRemoteVersion.description)
        
        // Update stellar env
        Logger().log("Updating stellarenv")
        try envInstaller.install(version: latestRemoteVersion.description)
        
        Logger().log("Stellar version \(latestRemoteVersion.description) installed")
    }
    
}
