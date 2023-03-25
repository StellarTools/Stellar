//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createAction(name: String,
                             at location: URL,
                             actionTemplatesLocation: URL,
                             hintTemplatesLocation: URL) throws {
        let actionLocation = location.appendingPathComponent(name, isDirectory: true)
        try fileManager.createFolder(at: actionLocation)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templater = Templater(templatingContext: context)
        do {
            try templater.templateFolder(source: actionTemplatesLocation, destination: actionLocation)
            let hintManager = HintManager(hintTemplatesLocation: hintTemplatesLocation)
            let hint = try hintManager.hintForActionCreated(name: name, url: actionLocation.relativePath)
            Logger.info?.write(hint)
            
        } catch {
            Logger.error?.write(error.localizedDescription)
            try fileManager.deleteFolder(at: actionLocation)
        }
    }
}
