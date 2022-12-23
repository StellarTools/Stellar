//  Command.swift

import ArgumentParser
import Foundation
import SampleAction

@main
struct Command: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Abstract")
    
    @Option(name: .long, help: "")
    private var argument: String
    
    func run() throws {
        let action = SampleAction(argument: argument)
        action.call()
    }
}

