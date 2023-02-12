
import Foundation
import ArgumentParser
import Stellar

struct UpdateCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Installs the latest version if it's not already installed"
        )
    }

    public func run() throws {
        Logger().log("Checking for updates...")
        try EnvInstaller().install(version: "3.15.0")
    }
    
}
