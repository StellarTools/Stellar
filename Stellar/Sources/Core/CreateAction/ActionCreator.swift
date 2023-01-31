//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createAction(name: String, at location: URL, templatesLocation: URL) throws {
        let actionLocation = location.appendingPathComponent(name)
        try fileManager.createFolder(at: actionLocation)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templatingFileManager = Templater(templatingContext: context)
        do {
            try templatingFileManager.templateFolder(source: templatesLocation, destination: actionLocation)
            
            if location.standardizedFileURL == URLManager().dotStellarActionUrl().standardizedFileURL {
                Logger().hint(try HintManager().hintForActionCreatedOnDefaultPath(with: name))
            }
            
        } catch {
            Logger().log(error.localizedDescription)
            try fileManager.deleteFolder(at: actionLocation)
        }
    }
}
