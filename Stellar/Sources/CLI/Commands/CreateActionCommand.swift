//  CreateActionCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct CreateActionCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-action",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "The name of the Action. Must have the \"Action\" suffix")
    private var name: String
    
    @Option(name: .shortAndLong, help: "The path in which create the action. Default <cwd>.stellar/Actions")
    private var path: String?
    
    @Option(name: .shortAndLong, help: "The path with the action templates. Default <cwd>/Templates")
    private var templates: String?
    
    func run() throws {
        try validate()
        let location = URLManager().dotStellarActionsLocation(path)
        let actionTemplatesLocation = TemplatesLocationFactory(templatesPath: templates).actionTemplatesLocation
        try ActionCreator().createAction(name: name, at: location, templatesLocation: actionTemplatesLocation)
    }
    
    func validate() throws {
        let suffix = "Action"
        guard name.hasSuffix(suffix) else {
            throw ValidationError("'name' must have '\(suffix)' suffix.")
        }
    }
}

