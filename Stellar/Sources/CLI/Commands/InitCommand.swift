//  InitCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct InitCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var path: String
    
    func run() throws {
        // for a project existing at the given 'path',
        // creates the Executor package inside a 'stellar' folder
    }
}

