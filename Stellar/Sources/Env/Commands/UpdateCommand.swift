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
    
    // MARK: - Functions

    func run() throws {
        Logger().log("Checking for updates...")
        try UpdateService().update()
    }
    
}
