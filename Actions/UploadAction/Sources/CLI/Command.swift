//  Command.swift

import ArgumentParser
import Foundation
import UploadAction

@main
struct Command: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var argument: String
    
    func run() throws {
        let action = UploadAction(argument: argument)
        action.call()
    }
}

