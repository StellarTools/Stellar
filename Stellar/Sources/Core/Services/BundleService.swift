import Foundation

// MARK: - BundleServer

public final class BundleService {
    
    // MARK: - Public Properties
    
    public let fileManager: FileManaging = FileManager.default
    
    public var versionResolver: VersionResolving {
        cliInstaller.versionResolver
    }
    
    public let cliInstaller: CLIInstaller

    // MARK: - Private Properties
    
    private let urlManager = URLManager()
    private let logger = Logger()
    
    
    // MARK: - Initialization

    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.cliInstaller = .init(releaseProvider: releaseProvider, versionResolver: versionResolver)
    }
    
    // MARK: - Public Methods
    
    /// Bundles the version specified in the `.stellar-version` file into the `.stellar-bin` directory.
    public func run() throws {
        let versionsFileURL = urlManager.currentWorkingDirectory().appendingPathComponent(FileConstants.versionsFile)
        let binFolderURL = urlManager.currentWorkingDirectory().appendingPathComponent(FileConstants.binFolder)

        guard fileManager.fileExists(at: versionsFileURL) else {
            // File .stellar-version in the cwd should include the version to bundle.
            throw Errors.missingVersionFile(versionsFileURL)
        }
        
        let targetVersion = try String(contentsOf: versionsFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
        logger.log("Bundling the version \(targetVersion) in \(binFolderURL.path)")
        
        if try !versionResolver.isVersionInstalled(targetVersion) {
            logger.log("Version \(targetVersion) not available locally. Installing...")
            try cliInstaller.install(version: targetVersion)
        }
        
        guard let versionPath = try versionResolver.pathForVersion(targetVersion) else {
            throw Errors.failedToIdentifyVersion(targetVersion)
        }
        
        try fileManager.deleteFolder(at: binFolderURL) // remove any other bundled version
        try fileManager.copyFile(from: versionPath, to: binFolderURL)
        
        logger.log("Stellar \(targetVersion) bundled successfully at \(binFolderURL.path)")
    }
    
}

// MARK: - BundleServer + Errors

extension BundleService {
    
    public enum Errors: Error {
        /// Specified path does not contains the .stellar-version with the version to bundle.
        case missingVersionFile(URL)
        /// Failed to identify local version
        case failedToIdentifyVersion(String)
    }
    
}
