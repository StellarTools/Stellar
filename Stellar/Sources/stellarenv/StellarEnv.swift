import ArgumentParser
import Foundation
import Stellar

@main
struct StellarEnv: AsyncParsableCommand {
    
    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "stellarenv",
            abstract: "Manage the environment stellar versions",
            subcommands: [
                LocalCommand.self,
                InstallCommand.self
            ]
        )
    }
    
}

