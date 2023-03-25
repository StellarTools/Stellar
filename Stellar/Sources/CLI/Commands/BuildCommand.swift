//  BuildCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct BuildCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Build the binary that runs the tasks."
    )
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    @Option(name: .shortAndLong, help: "The path to the project. Optional, defaults to the current directory.")
    private var projectPath: String = "./"
    
    // MARK - Methods
    
    func run() throws {
        Logger.verbose = verbose
        
        let location = URL(fileURLWithPath: projectPath)
        try Builder().build(at: location)
    }
}

