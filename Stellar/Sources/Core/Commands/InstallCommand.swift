import ArgumentParser
import Foundation

/// The following tool is used to install a version of stellar into the system.
public struct InstallCommand: AsyncParsableCommand {
    
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

    public func run() async throws {
        try await run(version: version)
    }
    
    public func run(version: String?) async throws {
        if let version { // install specified version
            try VersionsService().install(version: version)
        } else { // evaluate the latest stable/pre-release version avaiable
            let latestRelease = try await VersionsService().latestVersion(preRelease: preRelease)
            try VersionsService().install(version: latestRelease.description)
        }
    }
    
}
