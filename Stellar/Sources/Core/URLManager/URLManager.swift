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
        appLocation.appendingPathComponent(FolderConstants.dotStellarFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages
    func packagesUrl(at appLocation: URL) -> URL {
        dotStellarUrl(at: appLocation).appendingPathComponent(FolderConstants.packagesFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages/Executor
    func executorUrl(at appLocation: URL) -> URL {
        packagesUrl(at: appLocation).appendingPathComponent(FolderConstants.executorFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages/Executor/Sources
    func executorSourcesUrl(at appLocation: URL) -> URL {
        executorUrl(at: appLocation).appendingPathComponent(FolderConstants.sourcesFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Executables/
    func executablesUrl(at appLocation: URL) -> URL {
        dotStellarUrl(at: appLocation).appendingPathComponent(FolderConstants.executablesFolder, isDirectory: true)
    }
    
    // Default: <cwd>/Templates
    
    func templatesLocation() -> URL {
        currentLocation().appendingPathComponent(FolderConstants.templatesFolder)
    }
    
    func currentWorkingDirectory() -> URL {
        fileManager.currentLocation
    }
    
    func currentLocation() -> URL {
        fileManager.currentLocation.appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
    }
    
    // Default: <cwd>/Templates/Hints
    
    func hintsLocation() -> URL {
        templatesLocation().appendingPathComponent(FolderConstants.hintsFolder, isDirectory: true)
    }
    
    // MARK: - Stellar System Directories
    
    // Default: ~/.stellar
    
    /// Return the home of stellar in user's directory or a specified subfolder in the same root.
    ///
    /// - Parameter subfolder: optional subfolder.
    /// - Returns: full path.
    func systemLocation(subfolder: String? = nil) -> URL {
        let homeStellarURL = fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent(FolderConstants.dotStellarFolder)
        guard let subfolder else {
            return homeStellarURL
        }
        
        return homeStellarURL.appendingPathComponent(subfolder)
    }
    
    /// Return the installation URL of stellar for a specified version.
    ///
    /// - Parameter version: version to get.
    /// - Returns: path (it should be checked, it may not exists).
    func systemVersionsLocation(_ version: String? = nil) throws -> URL {
        var url = systemLocation().appendingPathComponent(FolderConstants.versionsFolder)
        if let version {
            url = url.appendingPathComponent(version)
        }
        
        if !fileManager.fileExists(at: url) {
            try fileManager.createFolder(at: url)
        }
        return url
    }
    
}
