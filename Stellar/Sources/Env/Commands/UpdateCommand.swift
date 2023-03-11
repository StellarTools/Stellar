
import Foundation
import ArgumentParser
import StellarCore

/// The `UpdateCommand` is used to update both the Stellar CLI and Stellar Env.
struct UpdateCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Install the latest version if not already installed."
        )
    }
    
    // MARK: - Public Functions

    public func run() throws {
        Logger().log("Checking for updates...")
        try UpdaterService().update()
    }
    
}
