import ArgumentParser
import Foundation
import Stellar

@main
struct Stellar: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "stellar",
        abstract: "Manage stellar versions",
        subcommands: [
            LocalCommand.self,
            ListCommand.self,
            InstallCommand.self
        ]
    )
}

