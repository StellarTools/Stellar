//  InstallCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct InstallCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "install",
            abstract: "Install a version of stellar."
        )
    }
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false

    @Argument(help: "The version of stellar to be installed.")
    var version: String?
    
    @Flag(help: "When no version is specified, set this tag to install latest stable/pre-release.")
    var preRelease: Bool = false
    
    // MARK: - Methods

    func run() throws {
        Logger.verbose = verbose
        try CLIService().install(version: version, preRelease: preRelease)
    }
    
}
