import ArgumentParser
import Foundation
import Stellar

/// The following tool is used to install a version of stellar into the system.
public struct InstallCommand: ParsableCommand {
    
    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "install",
            abstract: "Installs a version of stellar"
        )
    }
    
    // MARK: - Arguments

    @Argument(help: "The version of stellar to be installed")
    public var version: String?
    
    @Flag(help: "When no version is specified, set this tag to install latest stable/pre-release")
    public var preRelease: Bool = false
    
    // MARK: - Initialization
    
    public init() { }
    
    // MARK: - Public Functions

    public func run() throws {
        try InstallerManager().install(version: version, preRelease: preRelease)
    }
    
}
