//  UpdateCommand.swift

import Foundation
import ArgumentParser
import StellarCore

struct UninstallCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "uninstall",
            abstract: "Uninstall a version of Stellar."
        )
    }
    
    // MARK: - Options
    
    @Argument(help: "The version of to uninstall.")
    var version: String
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    // MARK: - Methods

    func run() throws {
        Logger.verbose = verbose
        try UninstallService().uninstall(version: version)
    }
}
