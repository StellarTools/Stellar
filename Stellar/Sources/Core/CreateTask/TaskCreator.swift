//  TaskCreator.swift

import Foundation

final public class TaskCreator {
    
    public init() {}
    
    public func createTask(name: String, at location: URL, templatesLocation: URL) throws {
        let taskTemplatesLocation = templatesLocation
            .appendingPathComponent("Task")
        let taskTemplateLocation = taskTemplatesLocation
            .appendingPathComponent("Task.stencil", isDirectory: false)
        let executorSourcesUrl = try URLManager().existingExecutorSourcesUrl(at: location)
        try TaskManager()
            .createTask(taskName: name,
                        templateLocation: taskTemplateLocation,
                        executorSourcesLocation: executorSourcesUrl)
    }
}
