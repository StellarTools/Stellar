import Foundation

protocol UpdaterManaging: AnyObject {
    
    func update() async throws
    
}

public final class UpdaterManager: UpdaterManaging {
    
    private var versionProvider = VersionProvider()
    private var installManager = InstallerManager()
    private var envInstaller = EnvInstaller()
    
    public init() {
        
    }
    
    public func update() async throws {
        guard let latestRemoteVersion = try await versionProvider.latestVersion() else {
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
        try await installManager.install(version: latestRemoteVersion.description)
        
        // Update stellar env
        Logger().log("Updating stellarenv")
        try await envInstaller.install(version: latestRemoteVersion.description)
    }
    
    
}
