//  Initializer.swift

import Foundation

final public class Initializer {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func install(at projectUrl: URL, templatesLocation: URL) throws {
        let executorLocation = urlManager.executorPackageUrl(at: projectUrl)
        try fileManager.createFolder(at: executorLocation)
        
        let context = TemplatingContextFactory().makeTemplatingContext(name: Constants.executor)
        let templater = Templater(templatingContext: context)
        do {
            try templater.templateFolder(source: templatesLocation, destination: executorLocation)
        } catch {
            Logger.error?.write(error.localizedDescription)
            try fileManager.deleteFolder(at: executorLocation)
        }
    }
}
