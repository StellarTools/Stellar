
import Foundation
import ArgumentParser
import Stellar

struct UpdateCommand: AsyncParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Installs the latest version if it's not already installed"
        )
    }

    public func run() async throws {
        Logger().log("Checking for updates...")
        
        try await EnvInstaller().install(version: "3.15.0")
        //try await UpdaterManager().update()
    }
    
}
