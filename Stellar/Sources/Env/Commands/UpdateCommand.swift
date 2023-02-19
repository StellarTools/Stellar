
import Foundation
import ArgumentParser
import Stellar

/// The `UpdateCommand` is used to update the currently installed binary of `stellarenv`.
struct UpdateCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Installs the latest version if it's not already installed"
        )
    }
    
    // MARK: - Public Functions

    public func run() throws {
        do {
            Logger().log("Checking for updates...")
            try EnvInstaller().install()
        } catch {
            Logger().log("Failed: \(error.localizedDescription)")
        }
    }
    
}
