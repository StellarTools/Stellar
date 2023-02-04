//  TemplatesLocations.swift

import Foundation

struct TemplatesLocationFactory {
    
    enum Folder {
        static let action = "Action"
        static let executor = "Executor"
        static let task = "Task"
    }
    
    private let templatesLocation: URL

    init(templatesPath: String? = nil, fileManager: FileManaging = FileManager.default) {
        templatesLocation = URLManager(fileManager: fileManager).templatesLocation(templatesPath)
    }
    
    var actionTemplatesLocation: URL {
        templatesLocation.appendingPathComponent(Folder.action)
    }
    
    var executorTemplatesLocation: URL {
        templatesLocation.appendingPathComponent(Folder.executor)
    }
    
    var taskTemplatesLocation: URL {
        templatesLocation.appendingPathComponent(Folder.task)
    }
}
