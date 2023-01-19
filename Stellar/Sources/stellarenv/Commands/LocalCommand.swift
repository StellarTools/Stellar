import Foundation
import ArgumentParser
import Stellar

struct LocalCommand: ParsableCommand {
    
    // MARK: - Properties
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "local",
            abstract: "Creates a .stellar-version file to pin the stellar version that should be used in the current directory. If the version is not specified, it prints the local versions."
        )
    }

    @Option(help: "The version that you would like to pin your current directory to")
    var version: String?
    
    @Option(help: "Directory path used when pin version. If not specified the current working directory.")
    var path: String?
    
    // MARK: - Public Functions
    
    func run() throws {
        try LocalService().run(version: version, path: path)
    }
    
}
