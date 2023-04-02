//  URLManager.swift

import Foundation

final class URLManager {
    
    private let fileManager: FileManaging
    
    init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: Paths
    
    // <app_path>/.stellar
    func dotStellarUrl(at appLocation: URL) -> URL {
        appLocation.appendingPathComponent(PathConstants.dotStellarFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages
    func packagesUrl(at appLocation: URL) -> URL {
        dotStellarUrl(at: appLocation).appendingPathComponent(PathConstants.packagesFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages/Executor
    func executorPackageUrl(at appLocation: URL) -> URL {
        packagesUrl(at: appLocation).appendingPathComponent(PathConstants.executorFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages/Executor/Sources
    func executorPackageSourcesUrl(at appLocation: URL) -> URL {
        executorPackageUrl(at: appLocation).appendingPathComponent(PathConstants.sourcesFolder, isDirectory: true)
    }

    // <app_path>/.stellar/Executables/
    func executablesUrl(at appLocation: URL) -> URL {
        dotStellarUrl(at: appLocation).appendingPathComponent(PathConstants.executablesFolder, isDirectory: true)
    }
    
    func currentWorkingDirectory() -> URL {
        fileManager.currentLocation
    }
    
    // MARK: - Stellar System Directories
    
    // Default: ~/.stellar
    
    /// Return the home of stellar in user's directory or a specified subfolder in the same root.
    ///
    /// - Parameter subfolder: optional subfolder.
    /// - Returns: full path.
    func homeStellarLocation(subfolder: String? = nil) -> URL {
        let homeStellarURL = fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent(PathConstants.dotStellarFolder)
        guard let subfolder else {
            return homeStellarURL
        }
        
        return homeStellarURL.appendingPathComponent(subfolder)
    }
    
    /// Return the location to the installed versions.
    ///
    /// - Returns: a URL to the folder containing the installed versions
    func cliVersionsLocation() throws -> URL {
        let url = homeStellarLocation(subfolder: PathConstants.versionsFolder)
        // not sure if we should create the folder
        if !fileManager.folderExists(at: url) {
            try fileManager.createFolder(at: url)
        }
        return url
    }
    
    /// Return the location of a specified installed version.
    ///
    /// - Parameter version: version to get.
    /// - Returns: a URL to the installed version
    func cliLocation(for version: String) throws -> URL {
        let url = homeStellarLocation(subfolder: PathConstants.versionsFolder)
            .appendingPathComponent(version)
        // not sure if we should create the folder
        if !fileManager.folderExists(at: url) {
            try fileManager.createFolder(at: url)
        }
        return url
    }

}
