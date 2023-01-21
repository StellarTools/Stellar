//  URLManager.swift

import ArgumentParser
import Foundation

final class URLManager {
    
    func actionsLocation(_ actions: String?) -> URL {
        if let actions = actions {
            return URL(fileURLWithPath: actions)
        }
        return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(FolderConstants.actionsFolder)
    }
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(FolderConstants.templatesFolder)
    }
    
}
