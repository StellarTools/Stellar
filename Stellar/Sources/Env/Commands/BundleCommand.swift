import ArgumentParser
import Foundation
import StellarCore

struct BundleCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "bundle",
            abstract: "Bundles the version specified in the .stellar-version file into the .stellar-bin directory"
        )
    }

    func run() throws {
        try BundleService().run()
    }
    
}
