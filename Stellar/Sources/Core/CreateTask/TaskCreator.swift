//  TaskCreator.swift

import Foundation

final public class TaskCreator {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createTask(name: String, at projectUrl: URL, templateLocation: URL) throws {
        let executorSourcesUrl = urlManager.executorPackageSourcesUrl(at: projectUrl)
        try fileManager.verifyFolderExisting(at: executorSourcesUrl)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templater = Templater(templatingContext: context)
        let destination = executorSourcesUrl.appendingPathComponent("\(name).swift", isDirectory: false)
        try templater.templateFile(source: templateLocation, destination: destination)
    }
}
