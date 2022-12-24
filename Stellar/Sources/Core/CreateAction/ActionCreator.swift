//  ActionCreator.swift

import Foundation

final public class ActionCreator {
    
    enum ActionCreatorError: Error {
        case invalidActionName(String)
    }
    
    public init() {}
    
    public func createAction(name: String, at location: URL, templatesLocation: URL) throws {
        try validateName(name)
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
        let testTemplateLocation = templatesLocation
            .appendingPathComponent("Tests", isDirectory: true)
            .appendingPathComponent("ActionTests.stencil", isDirectory: false)
        
        let taskManager = TaskManager()
        do {
            try taskManager
                .createPackageFolder(at: location, packageName: name)
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
                            templateLocation: testTemplateLocation,
                            packageLocation: packageLocation)
        } catch {
            Logger.log(error.localizedDescription)
            try taskManager
                .deletePackage(at: location, packageName: name)
        }
    }
    
    private func validateName(_ name: String) throws {
        guard name.hasSuffix("Action") else {
            Logger.log("Actions must have 'Action' suffix.")
            throw ActionCreatorError.invalidActionName(name)
        }
    }
}
