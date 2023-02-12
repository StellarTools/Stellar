//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createAction(name: String, at location: URL, templatesLocation: URL) throws {
        let actionLocation = location.appendingPathComponent(name, isDirectory: true)
        try fileManager.createFolder(at: actionLocation)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templater = Templater(templatingContext: context)
        do {
            try templater.templateFolder(source: templatesLocation, destination: actionLocation)
            
            Logger().hint(try HintManager().hintForActionCreatedOnDefaultPath(with: actionLocation.relativePath, name: name))
            
        } catch {
            Logger().log(error.localizedDescription)
            try fileManager.deleteFolder(at: actionLocation)
        }
    }
}
