//  CreateActionCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct CreateActionCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-action",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var name: String
    
    @Option(name: .shortAndLong, help: "")
    private var path: String
    
    @Option(name: .shortAndLong, help: "")
    private var templates: String?
    
    func run() throws {
        let location = URL(fileURLWithPath: path)
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

