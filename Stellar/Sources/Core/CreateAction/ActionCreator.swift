//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    public init() {}
    
    public func createAction(name: String, at location: URL, templatesLocation: URL) throws {
        let packageLocation = location
            .appendingPathComponent(name, isDirectory: true)
        
        let packageDotSwiftTemplateLocation = templatesLocation
            .appendingPathComponent("Package.stencil", isDirectory: false)
        let readmeTemplateLocation = templatesLocation
            .appendingPathComponent("README.stencil", isDirectory: false)
        let actionTemplateLocation = templatesLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("Action", isDirectory: true)
            .appendingPathComponent("Action.stencil", isDirectory: false)
        let commandTemplateLocation = templatesLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("CLI", isDirectory: true)
            .appendingPathComponent("Command.stencil", isDirectory: false)
        let testsTemplateLocation = templatesLocation
            .appendingPathComponent("Tests", isDirectory: true)
            .appendingPathComponent("ActionTests.stencil", isDirectory: false)
        
        let taskManager = TaskManager()
        try taskManager
            .createFolder(at: location, name: name)
        do {
            try taskManager
                .initPackage(at: packageLocation)
                .createPackageDotSwift(packageName: name,
                                       templateLocation: packageDotSwiftTemplateLocation,
                                       packageLocation: packageLocation)
                .createReadme(packageName: name,
                              templateLocation: readmeTemplateLocation,
                              packageLocation: packageLocation)
                .deleteSourcesFolder(packageLocation: packageLocation)
                .deleteTestsFolder(packageLocation: packageLocation)
                .createActionSource(packageName: name,
                                    templateLocation: actionTemplateLocation,
                                    packageLocation: packageLocation)
                .createCommandSource(packageName: name,
                                     templateLocation: commandTemplateLocation,
                                     packageLocation: packageLocation)
                .createTest(packageName: name,
                            templateLocation: testsTemplateLocation,
                            packageLocation: packageLocation)
            
            if location == URLManager().actionsLocation() {
                let hint = try HintManager().hintForActionCreatedOnDefaultPath(with: name)
                Logger().hint(hint)
            }
            
        } catch {
            Logger().log(error.localizedDescription)
            try taskManager
                .deletePackage(at: packageLocation)
        }
    }
}
