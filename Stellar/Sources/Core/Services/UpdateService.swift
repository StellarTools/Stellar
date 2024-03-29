//  UpdateService.swift

import Foundation

// MARK: - UpdateServiceProtocol

protocol UpdateServiceProtocol: AnyObject {
        
    /// Download and update both CLI and Env tools to the specified version.
    ///
    /// - Parameter version: version to update. if `nil` a check with the latest remote release is made.
    @discardableResult
    func update(to version: String?) throws -> URL?
    
}

// MARK: - UpdateService

public final class UpdateService: UpdateServiceProtocol {
    
    // MARK: - Public Properties
    
    public let cliService: CLIService
    public let envService: EnvService
        
    public var releaseProvider: ReleaseProviding {
        cliService.releaseProvider
    }
    
    public var versionResolver: VersionResolving {
        cliService.versionResolver
    }
        
    // MARK: - Initialization
    
    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.cliService = .init(releaseProvider: releaseProvider, versionResolver: versionResolver)
        self.envService = .init(releaseProvider: releaseProvider)
    }
    
    // MARK: - Public Functions
    
    @discardableResult
    public func update(to version: String? = nil) throws -> URL? {
        Logger.info?.write("Checking for updates...")
        if let version {
            return try update(toVersion: version)
        } else {
            return try updateToLatestVersion()
        }
    }

    // MARK: - Private Functions
    
    private func update(toVersion version: String) throws -> URL? {
        // Version is not available locally, we retrive it remotely.
        if try versionResolver.isVersionInstalled(version) == false {
            Logger.info?.write("Version \(version) not found locally. Installing...")
            return try cliService.install(version: version)
        }
        
        // Attempt to get the path of the release.
        let versionPath = try versionResolver.pathForVersion(version).path
        return URL(fileURLWithPath: versionPath)
    }

    private func updateToLatestVersion() throws -> URL? {
        guard let release = try releaseProvider.latestRelease() else {
            Logger.error?.write("No remote version found")
            return nil
        }
        
        let versionURL = try updateCLIToLatestVersion(release.version)
        try updateEnvToLatestVersion(release.version)
        
        Logger.info?.write("Stellar version \(release.description) installed")
        
        return versionURL
    }
        
    private func updateCLIToLatestVersion(_ version: SemVer) throws -> URL? {
        if let latestLocalVersion = try cliService.latestInstalledVersion() {
            guard version > latestLocalVersion.version else {
                Logger.info?.write("Version \(latestLocalVersion) is installed and greater than latest available \(version)")
                return nil
            }
            
            Logger.info?.write("Installing new version available \(version)")
        } else {
            Logger.info?.write("No local version available. Installing latest version \(version)")
        }
        
        // Install version of stellar
        return try cliService.install(version: version.description)
    }
    
    private func updateEnvToLatestVersion(_ version: SemVer) throws {
        Logger.info?.write("Updating stellarenv")
        try envService.install(version: version.description)
    }
    
}
