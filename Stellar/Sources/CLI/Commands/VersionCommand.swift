//  VersionCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct VersionCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "version",
        abstract: "Output the current version of the tool."
    )
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    // MARK: - Methods
    
    func run() throws {
        Logger.verbose = verbose

        try VersionService().run()
    }
    
}
