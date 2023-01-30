//  URLManager.swift

import Foundation

final class URLManager {
    
    // MARK: Paths
    
    // <app_path>/.stellar
    func stellarUrl(at appLocation: URL) -> URL {
        appLocation.appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
    }
    
    // <app_path>/.stellar/Packages
    func packagesUrl(at appLocation: URL) -> URL {
        stellarUrl(at: appLocation).appendingPathComponent(FolderConstants.packagesFolder, isDirectory: true)
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
        stellarUrl(at: appLocation).appendingPathComponent(FolderConstants.executablesFolder, isDirectory: true)
    }
}
