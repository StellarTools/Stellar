//  BuildCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct BuildCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Build the binary that runs the tasks.")
    
    @Option(name: .shortAndLong, help: "The path to the project. Optional, defaults to the current directory.")
    private var projectPath: String = "./"
    
    func run() throws {
        let location = URL(fileURLWithPath: projectPath)
        try Builder().build(at: location)
    }
}

