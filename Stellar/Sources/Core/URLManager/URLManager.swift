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
        fileManager.currentLocation.appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
    }
    
    // Default: <cwd>/Templates/Hints
    
    func hintFolderLocation() -> URL {
        
        if let x = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] {
            //            print(Bundle.allBundles)
            //            let x = Bundle.module.url(forResource: template, withExtension: "stencil")
            //            let y = Bundle.module.url(forResource: "Templates/test", withExtension: "txt")
            //            let fileManager = FileManager.default
            return Bundle.module.resourceURL!.appendingPathComponent(FolderConstants.resourcesFolder, isDirectory: true)
                .appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
                .appendingPathComponent(FolderConstants.resourcesFolder, isDirectory: true)
                .appendingPathComponent(FolderConstants.stringsFolder, isDirectory: true)
                .appendingPathComponent(FolderConstants.hintsFolder, isDirectory: true)
            //let docsArray = try? fileManager.contentsOfDirectory(atPath: Bundle.module.resourcePath! + "/Templates")
        }
        
        
        return fileManager.currentLocation.appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.resourcesFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.stringsFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.hintsFolder, isDirectory: true)
    }

    func hintsLocation() -> URL {
        templatesLocation().appendingPathComponent(FolderConstants.hintsFolder, isDirectory: true)

    }
}
