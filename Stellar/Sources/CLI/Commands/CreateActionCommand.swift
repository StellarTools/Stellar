//  CreateActionCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct CreateActionCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-action",
        abstract: "Abstract")
    
    @Option(name: .long, help: "")
    private var argument: String
    
    func run() throws {
        // creates a package following a template
    }
}

