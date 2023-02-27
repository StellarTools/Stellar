import Foundation

protocol BundleUpdating: AnyObject {
        
    /// Download and update both CLI and Env tools to the specified version.
    ///
    /// - Parameter version: version to update. if `nil` a check with the latest remote release is made.
    @discardableResult
    func update(toVersion version: String?) throws -> URL?
    
}

// MARK: - BundleUpdater

public final class BundleUpdater: BundleUpdating {
    
    // MARK: - Public Properties
    
    public var cliInstaller: CLIInstaller
    public var envInstaller: EnvInstaller
    
    public var releaseProvider: ReleaseProviding {
        cliInstaller.releaseProvider
    }
    
    public var versionResolver: VersionResolving {
        cliInstaller.versionResolver
    }
        
    // MARK: - Initialization
    
    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.cliInstaller = .init(releaseProvider: releaseProvider, versionResolver: versionResolver)
        self.envInstaller = .init(releaseProvider: releaseProvider)
    }
    
    // MARK: - Public Functions
    
    func update(toVersion version: String?) throws -> URL? {
        if let version {
            return try updateBundle(toVersion: version)
        } else {
            return try updateBundleToLatestVersion()
        }
    }

    // MARK: - Private Functions
    
    private func updateBundle(toVersion version: String) throws -> URL? {
        // Version is not available locally, we would to retrive it remotely.
        if try versionResolver.isVersionInstalled(version) == false {
            Logger().log("Version \(version) not found locally. Installing...")
            return try cliInstaller.install(version: version)
        }
        
        // Attempt to get the path of the release.
        guard let versionPath = try versionResolver.pathForVersion(version)?.path else {
            Logger().log("Failed to use version \(version). Aborting the process...")
            return nil
        }
        
        return URL(fileURLWithPath: versionPath)
    }

    private func updateBundleToLatestVersion() throws -> URL? {
        guard let release = try releaseProvider.latestRelease() else {
            Logger().log("No remote version found")
            return nil
        }
        
        let versionURL = try updateCLI(toRemoteVersion: release)
        try updateENV(toRemoteVersion: release)
        
        Logger().log("Stellar version \(release.description) installed")
        
        return versionURL
    }
        
    private func updateCLI(toRemoteVersion version: RemoteRelease) throws -> URL? {
        if let latestLocalVersion = try cliInstaller.latestInstalledVersion() {
            guard version.version > latestLocalVersion.version else {
                Logger().log("There are not updates available")
                return nil
            }
            
            Logger().log("Installing new version available \(version)")
        } else {
            Logger().log("No local version available. Installing latest version \(version)")
        }
        
        // Install version of stellar
        return try cliInstaller.install(version: version.description)
    }
    
    private func updateENV(toRemoteVersion version: RemoteRelease) throws {
        Logger().log("Updating stellarenv")
        try envInstaller.install(version: version.description)
    }
    
}
