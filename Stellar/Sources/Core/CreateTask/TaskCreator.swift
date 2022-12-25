//  TaskCreator.swift

import Foundation

final public class TaskCreator {
    
    public init() {}
    
    public func createTask(name: String, at location: URL, templatesLocation: URL) throws {
        let taskTemplateLocation = templatesLocation
            .appendingPathComponent("Task.stencil", isDirectory: false)
        let executorSourcesUrl = try URLManager().executorSourcesUrl(at: location)
        try TaskManager()
            .createTask(taskName: name,
                        templateLocation: taskTemplateLocation,
                        executorSourcesLocation: executorSourcesUrl)
    }
}
