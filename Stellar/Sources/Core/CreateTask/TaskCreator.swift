//  TaskCreator.swift

import Foundation

final public class TaskCreator {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createTask(name: String, at location: URL, templateLocation: URL) throws {
        let executorSourcesUrl = urlManager.executorSourcesUrl(at: location)
        try fileManager.verifyFolderExisting(at: executorSourcesUrl)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templatingFileManager = Templater(templatingContext: context)
        try templatingFileManager.templateFile(source: templateLocation, destination: executorSourcesUrl, filename: "\(name).swift")
    }
}
