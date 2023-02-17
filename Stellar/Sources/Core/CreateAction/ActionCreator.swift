//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func createAction(name: String,
                             at location: PathSpec,
                             actionTemplatesLocation: URL,
                             hintTemplatesLocation: URL) throws {
        let actionLocation = location.url.appendingPathComponent(name, isDirectory: true)
        try fileManager.createFolder(at: actionLocation)
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        let templater = Templater(templatingContext: context)
        do {
            try templater.templateFolder(source: actionTemplatesLocation, destination: actionLocation)
            
            if location.isDefault {
                let hintManager = HintManager(hintTemplatesLocation: hintTemplatesLocation)
                let hint = try hintManager.hintForActionCreatedOnDefaultPath(with: name)
                Logger().hint(hint)
            }
            
        } catch {
            Logger().log(error.localizedDescription)
            try fileManager.deleteFolder(at: actionLocation)
        }
    }
}
