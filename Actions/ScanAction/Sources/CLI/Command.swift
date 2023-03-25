//  Command.swift

import ArgumentParser
import Foundation
import ScanAction

@main
struct Command: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var argument: String
    
    func run() throws {
        let action = ScanAction(argument: argument)
        action.call()
    }
}

