//  EditCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct EditCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "edit",
        abstract: "Open the project handling tasks for a Swift project.")

    @Option(name: .shortAndLong, help: "The path to the project. Optional, defaults to the current directory.")
    private var projectPath: String = "./"
    
    func run() throws {
        let location = URL(fileURLWithPath: projectPath)
        try Editor().edit(at: location)
    }
}

