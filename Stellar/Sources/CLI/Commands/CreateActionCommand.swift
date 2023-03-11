//  CreateActionCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct CreateActionCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-action",
        abstract: "Create an action that can be used by the tasks.")
    
    @Option(name: .shortAndLong, help: "The name of the Action. Must have the 'Action' suffix.")
    private var name: String
    
    @Option(name: .shortAndLong, help: "The path in which to create the action. Optional, defaults to .stellar/Actions")
    private var outputPath: String?
    
    @Option(name: .shortAndLong, help: "The path to the templates. Optional, defaults to the templates shipped with the release.")
    private var templatesPath: String?
    
    func run() throws {
        try validate()
        let location = URLManager().dotStellarActionsLocation(outputPath)
        let templatesLocationFactory = TemplatesLocationFactory(templatesPath: templatesPath)
        let actionTemplatesLocation = templatesLocationFactory.actionTemplatesLocation
        let hintTemplatesLocation = templatesLocationFactory.hintTemplatesLocation
        try ActionCreator().createAction(name: name,
                                         at: location,
                                         actionTemplatesLocation: actionTemplatesLocation,
                                         hintTemplatesLocation: hintTemplatesLocation)
    }
    
    func validate() throws {
        let suffix = "Action"
        guard name.hasSuffix(suffix) else {
            throw ValidationError("'name' must have '\(suffix)' suffix.")
        }
    }
}

