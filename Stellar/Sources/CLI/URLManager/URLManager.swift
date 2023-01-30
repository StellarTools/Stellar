//  URLManager.swift

import Foundation

final class URLManager {
    
    private let fileManager: FileManaging
    
    init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return fileManager.currentLocation.appendingPathComponent(FolderConstants.templatesFolder)
    }
}
