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
    
    func dotStellarActionsLocation(_ actions: String? = nil) -> PathSpec {
        if let actions = actions {
            return (URL(fileURLWithPath: actions), false)
        }
        return (fileManager.currentLocation.appendingPathComponent(FolderConstants.dotStellarActionsFolder), true)
    }
    
    // Default: <cwd>/.stellar/Templates
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return fileManager.currentLocation.appendingPathComponent(FolderConstants.templatesFolder)
    }
    
}
