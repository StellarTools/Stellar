//  URLManager.swift

import Foundation
import Stellar

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
        return fileManager.currentLocation.appendingPathComponent(FolderConstants.dotStellarActionsFolder)
    }
    
    // Default: <cwd>/Templates
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return fileManager.currentLocation.appendingPathComponent(FolderConstants.templatesFolder)
    }
}
