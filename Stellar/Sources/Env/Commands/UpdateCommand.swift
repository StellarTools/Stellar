
import Foundation
import ArgumentParser
import StellarCore

/// The `UpdateCommand` is used to update the currently installed binary of `stellarenv`.
struct UpdateCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Install the latest version if not already installed."
        )
    }
    
    // MARK: - Public Functions

    public func run() throws {
        Logger().log("Checking for stellarenv updates...")
        try EnvInstaller().install()
    }
    
}
