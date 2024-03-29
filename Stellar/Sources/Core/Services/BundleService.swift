//  BundleService.swift

import Foundation

// MARK: - BundleService

/// `BundleService` is used to bundle a particular version of the stellar cli into a project.
public final class BundleService {
    
    // MARK: - Public Properties
    
    public let fileManager: FileManaging = FileManager.default
    
    public var versionResolver: VersionResolving {
        cliService.versionResolver
    }
    
    public let cliService: CLIService

    // MARK: - Private Properties
    
    private let urlManager = URLManager()
    
    // MARK: - Initialization
    
    /// Initialize bundle service.
    ///
    /// - Parameters:
    ///   - releaseProvider: releases provider.
    ///   - versionResolver: versions resolver.
    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.cliService = .init(releaseProvider: releaseProvider, versionResolver: versionResolver)
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
        Logger.info?.write("Bundling the version \(targetVersion) in \(binFolderURL.path)")
        
        if try !versionResolver.isVersionInstalled(targetVersion) {
            Logger.info?.write("Version \(targetVersion) not available locally. Installing...")
            try cliService.install(version: targetVersion)
        }
        
        let versionPath = try versionResolver.pathForVersion(targetVersion)
        if fileManager.folderExists(at: binFolderURL) {
            try fileManager.deleteFolder(at: binFolderURL) // remove any other bundled version
        }
        
        try fileManager.copyFile(at: versionPath, to: binFolderURL)
        
        Logger.info?.write("Stellar \(targetVersion) bundled successfully at \(binFolderURL.path)")
    }
    
}

// MARK: - Errors

extension BundleService {
    
    public enum Errors: FatalError {
        /// Specified path does not contains the .stellar-version with the version to bundle.
        case missingVersionFile(URL)
        
        public var type: ErrorType {
            .abort
        }
        
        public var description: String {
            switch self {
            case .missingVersionFile(let versionFileURL):
                return "Couldn't find a .stellar-version file in the directory \(versionFileURL.path)"
            }
        }
    }
    
}
