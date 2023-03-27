//  BundleCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct BundleCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "bundle",
            abstract: "Bundle the version specified in the .stellar-version file into the .stellar-bin directory."
        )
    }
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false

    // MARK: - Methods
    
    func run() throws {
        Logger.verbose = verbose
        try BundleService().run()
    }
    
}
