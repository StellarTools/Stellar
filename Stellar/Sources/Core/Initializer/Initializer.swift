//  Initializer.swift

import Foundation

final public class Initializer {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func install(at appLocation: URL, templatesLocation: URL) throws {
        let executorLocation = urlManager.executorUrl(at: appLocation)
        try fileManager.createFolder(at: executorLocation)
        
        let context = TemplatingContextFactory().makeTemplatingContext(name: Constants.executor)
        let templatingFileManager = Templater(templatingContext: context)
        do {
            try templatingFileManager.templateFolder(source: templatesLocation, destination: executorLocation)
        } catch {
            Logger().log(error.localizedDescription)
            try fileManager.deleteFolder(at: executorLocation)
        }
    }
}
