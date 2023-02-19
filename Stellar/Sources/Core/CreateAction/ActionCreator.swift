//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createAction(name: String, at location: PathSpec, templatesLocation: URL) throws {
        let actionLocation = location.url.appendingPathComponent(name, isDirectory: true)
        try fileManager.createFolder(at: actionLocation)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templater = Templater(templatingContext: context)
        do {
            try templater.templateFolder(source: templatesLocation, destination: actionLocation)
            
            if location.isDefault {
                Logger().hint(try HintManager(fileManager: fileManager).hintForActionCreatedOnDefaultPath(with: name))
            }
            
        } catch {
            Logger().log(error.localizedDescription)
            try fileManager.deleteFolder(at: actionLocation)
        }
    }
}
