import Foundation

public final class VersionsService {
    
        
    public init() { }
    
    /// Return installed local versions of stellar.
    ///
    /// - Returns: list of installed versions.
    public func installedVersions() throws -> [InstalledVersion] {
        URLManager().environmentURL.glob("*").compactMap { InstalledVersion(path: $0) }.sorted()
    }
    
    /// Return the latest version available in project page.
    ///
    /// - Parameter preRelease: `true` to return the latest pre-release version.
    /// - Returns: found version
    public func latestVersion(preRelease: Bool = false) async throws -> InstalledVersion {
        // TODO: Implement
        fatalError()
    }
    
    /// Pin a project to a specific stellar version by creating a custom `.stellar-version` at path.
    ///
    /// - Parameters:
    ///   - version: version to pin.
    ///   - path: path where to put the file.
    public func pin(version: String, atPath path: String?) throws {
        let currentURL = URL(fileURLWithPath: path ?? FileManager.default.currentDirectoryPath)
        
        Logger().log("Generating \(FileConstants.versionFileName) file with version \(version)")
        let fileURL = currentURL.appendingPathComponent(FileConstants.versionFileName)
        try "\(version)".write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )
        Logger().log("File generated at path \(fileURL.path)")
    }
    
    /// Install a specific version fo the stellar environment.
    ///
    /// - Parameters:
    ///   - version: version to install.
    ///   - temporaryPath: temporary directory where to install the version
    public func install(version: String, temporaryPath: String? = nil) throws -> String? {
        let releaseURL = URL(string: "\(Constants.githubProjectURL)/releases/download/\(version)/stellar.zip")!
        let installationPath = try System.shared.which("stellar")

        return try FileManager.default.withTemporaryDirectory(path: temporaryPath) { tempURL in
            Logger().log("Downloading Stellar version \(version)...")
            let downloadURL = tempURL.appendingPathComponent(FolderConstants.Installation.packageName)
            // try System.shared.run(["/usr/bin/curl", "-LSs", "--output", downloadPath.pathString, bundleURL.absoluteString])

            Logger().log("Installing...")
            // try System.shared.run(["/usr/bin/unzip", "-q", downloadPath.pathString, "tuistenv", "-d", temporaryDirectory.pathString])

            // Remove old version of stellar from system directory
            let removeArgs = ["rm", installationPath]
            /*do {
                try System.shared.run(removeArgs)
            } catch {
                try System.shared.run(["sudo"] + removeArgs)
            }*/
            
            // Move installed directory.
            let moveArgs = ["mv", tempURL.appendingPathComponent(FolderConstants.Installation.binaryName).path, installationPath]
            /*do {
                try System.shared.run(moveArgs)
            } catch {
                try System.shared.run(["sudo"] + moveArgs)
            }*/
            
            Logger().log("Stellar \(version) installed successfully!")
            return temporaryPath
        }
    }
    
    
}
