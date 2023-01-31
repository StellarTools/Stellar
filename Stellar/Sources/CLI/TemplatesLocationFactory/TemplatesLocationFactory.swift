//  TemplatesLocations.swift

import Foundation

struct TemplatesLocationFactory {
    
    private enum Folder: String {
        case action = "Action"
        case executor = "Executor"
        case task = "Task"
    }
    
    private let templatesLocation: URL
    
    init(templatesPath: String? = nil) {
        templatesLocation = URLManager().templatesLocation(templatesPath)
    }
    
    var actionTemplatesLocation: URL {
        templatesLocation.appendingPathComponent(Folder.action.rawValue)
    }
    
    var executorTemplatesLocation: URL {
        templatesLocation.appendingPathComponent(Folder.executor.rawValue)
    }
    
    var taskTemplatesLocation: URL {
        templatesLocation.appendingPathComponent(Folder.task.rawValue)
    }
}
