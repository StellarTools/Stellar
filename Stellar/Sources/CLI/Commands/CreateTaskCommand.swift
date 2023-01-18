//  CreateTaskCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct CreateTaskCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-task",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var name: String
    
    @Option(name: .shortAndLong, help: "")
    private var appPath: String
    
    @Option(name: .shortAndLong, help: "")
    private var templates: String?
    
    func run() throws {
        let location = URL(fileURLWithPath: appPath)
        let templatesLocation = URLManager().templatesLocation(templates)
        try TaskCreator().createTask(name: name, at: location, templatesLocation: templatesLocation)
    }
    
    func validate() throws {
        let suffix = "Task"
        guard name.hasSuffix(suffix) else {
            throw ValidationError("'name' must have '\(suffix)' suffix.")
        }
    }
}

