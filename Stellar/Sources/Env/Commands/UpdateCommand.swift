//  UpdateCommand.swift

import Foundation
import ArgumentParser
import StellarCore

struct UpdateCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Install the latest version if not already installed."
        )
    }
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    // MARK: - Methods

    func run() throws {
        Logger.verbose = verbose
        try UpdateService().update()
    }
    
}
