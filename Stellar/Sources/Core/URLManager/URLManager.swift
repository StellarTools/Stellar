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
    
    func currentLocation() -> URL {
        fileManager.currentLocation
    }
    
    // Default: <cwd>/Stellar/Templates/Resources/Strings/Hints
    
    func hintFolderLocation() -> URL {
        fileManager.currentLocation.appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.resourcesFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.stringsFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.hintsFolder, isDirectory: true)
    }
    
    // MARK: - Stellar System Directories
    
    // Default: ~/.stellar
    
    func systemLocation(subfolder: String? = nil) -> URL {
        let homeStellarURL = fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent(FolderConstants.dotStellarFolder)
        guard let subfolder else {
            return homeStellarURL
        }
        
        return homeStellarURL.appendingPathComponent(subfolder)
    }
    
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
