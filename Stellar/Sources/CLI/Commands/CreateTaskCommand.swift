//  CreateTaskCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct CreateTaskCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-task",
        abstract: "Create a task for a Swift project.")
    
    @Option(name: .shortAndLong, help: "The name of the Task. Must have the 'Task' suffix.")
    private var name: String
    
    @Option(name: .shortAndLong, help: "The path to the project. Optional, defaults to the current directory.")
    private var projectPath: String = "./"
    
    @Option(name: .shortAndLong, help: "The path to the templates. Optional, defaults to the templates shipped with the release.")
    private var templatesPath: String?
    
    func run() throws {
        let location = URL(fileURLWithPath: projectPath)
        let taskTemplateLocation = TemplatesLocationFactory(templatesPath: templatesPath).taskTemplatesLocation
            .appendingPathComponent("Task.stencil", isDirectory: false)
        try TaskCreator().createTask(name: name, at: location, templateLocation: taskTemplateLocation)
    }
    
    func validate() throws {
        let suffix = "Task"
        guard name.hasSuffix(suffix) else {
            throw ValidationError("'name' must have '\(suffix)' suffix.")
        }
    }
}

