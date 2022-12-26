//  TaskManager.swift

import Foundation
import ShellOut

public struct TaskManager {
    
    public init() {}
    
    let verbose: Bool = false
    
    var outputHandle: FileHandle? {
        verbose ? FileHandle.standardOutput : nil
    }
    
    var errorHandle: FileHandle? {
        verbose ? FileHandle.standardError : nil
    }
    
    @discardableResult
    func deletePackage(at location: URL) throws -> Self {
        Logger().log("Removing package folder...")
        try FileManager.default.removeItem(atPath: location.path)
        return self
    }
    
    @discardableResult
    func createFolder(at location: URL, name: String) throws -> Self {
        Logger().log("Creating package folder...")
        let folder = location
            .appendingPathComponent(name)
        try Writer().createFolderIfMissing(at: folder)
        return self
    }
    
    @discardableResult
    func initPackage(at location: URL) throws -> Self {
        Logger().log("Initialising package...")
        try shellOut(
            to: "swift",
            arguments: ["package", "init"],
            at: location.path,
            outputHandle: outputHandle,
            errorHandle: errorHandle)
        return self
    }
    
    @discardableResult
    func createPackageDotSwift(packageName: String, templateLocation: URL, packageLocation: URL) throws -> Self {
        Logger().log("Creating Package.swift...")
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: packageName])
        let packageDotSwiftLocation = packageLocation
            .appendingPathComponent("Package.swift", isDirectory: false)
        try Writer().write(content: content, to: packageDotSwiftLocation)
        return self
    }
    
    @discardableResult
    func createReadme(packageName: String, templateLocation: URL, packageLocation: URL) throws -> Self {
        Logger().log("Creating README.md...")
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: packageName])
        let readmeLocation = packageLocation
            .appendingPathComponent("README.md", isDirectory: false)
        try Writer().write(content: content, to: readmeLocation)
        return self
    }
    
    @discardableResult
    func deleteSourcesFolder(packageLocation: URL) throws -> Self {
        Logger().log("Removing Sources...")
        let sourcesLocation = packageLocation
            .appendingPathComponent("Sources", isDirectory: true)
        try FileManager.default.removeItem(atPath: sourcesLocation.path)
        return self
    }
    
    @discardableResult
    func deleteTestsFolder(packageLocation: URL) throws -> Self {
        Logger().log("Removing Tests...")
        let sourcesLocation = packageLocation
            .appendingPathComponent("Tests", isDirectory: true)
        try FileManager.default.removeItem(atPath: sourcesLocation.path)
        return self
    }
    
    @discardableResult
    func createActionSource(packageName: String, templateLocation: URL, packageLocation: URL) throws -> Self {
        Logger().log("Creating Sources [Action]...")
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: packageName])
        let actionSourceLocation = packageLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("Action", isDirectory: true)
            .appendingPathComponent("Action.swift", isDirectory: false)
        try Writer().write(content: content, to: actionSourceLocation)
        return self
    }
    
    @discardableResult
    func createCommandSource(packageName: String, templateLocation: URL, packageLocation: URL) throws -> Self {
        Logger().log("Creating Sources [Command]...")
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: packageName])
        let commandSourceLocation = packageLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("CLI", isDirectory: true)
            .appendingPathComponent("Command.swift", isDirectory: false)
        try Writer().write(content: content, to: commandSourceLocation)
        return self
    }
    
    @discardableResult
    func createTest(packageName: String, templateLocation: URL, packageLocation: URL) throws -> Self {
        Logger().log("Creating Tests...")
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: packageName])
        let testsLocation = packageLocation
            .appendingPathComponent("Tests", isDirectory: true)
            .appendingPathComponent("ActionTests.swift", isDirectory: false)
        try Writer().write(content: content, to: testsLocation)
        return self
    }
    
    @discardableResult
    func createTask(taskName: String, templateLocation: URL, executorSourcesLocation: URL) throws -> Self {
        Logger().log("Creating Task...")
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: taskName])
        let taskLocation = executorSourcesLocation
            .appendingPathComponent("\(taskName).swift", isDirectory: false)
        try Writer().write(content: content, to: taskLocation)
        return self
    }
    
    @discardableResult
    func createExecutorSourceFile(packageName: String, templateLocation: URL, packageLocation: URL) throws -> Self {
        Logger().log("Creating Sources...")
        let filename = templateLocation
            .deletingPathExtension()
            .lastPathComponent
        let templater = Templater(templatePath: templateLocation.path)
        let content = try templater.renderTemplate(context: [TemplateConstants.name: packageName])
        let sourceFileLocation = packageLocation
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("\(filename).swift", isDirectory: false)
        try Writer().write(content: content, to: sourceFileLocation)
        return self
    }
}
