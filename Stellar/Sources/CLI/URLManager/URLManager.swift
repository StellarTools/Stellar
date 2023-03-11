//  URLManager.swift

import Foundation
import StellarCore

final class URLManager {
    
    private let fileManager: FileManaging
    
    init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: Paths
    
    // Default: <cwd>/.stellar/Actions
    
    func dotStellarActionsLocation(_ actions: String? = nil) -> URL {
        if let actions = actions {
            return URL(fileURLWithPath: actions)
        }
        return fileManager.currentLocation
            .appendingPathComponent(PathConstants.dotStellarFolder)
            .appendingPathComponent(PathConstants.actionsFolder)
    }
    
    // Default: <cwd>/.stellar/Templates
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return fileManager.executableLocation.appendingPathComponent(PathConstants.templatesBundle)
    }
    
}
