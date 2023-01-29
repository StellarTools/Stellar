import Foundation
import ArgumentParser

/// The following command is used to list installed versions of
/// stellar or pin a project to a specified version tag.
public struct LocalCommand: ParsableCommand {
    
    // MARK: - Properties
    
    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "local",
            abstract: "Creates a .stellar-version file to pin the stellar version that should be used in the current directory. If the version is not specified, it prints the local versions."
        )
    }
    
    // MARK: - Arguments

    @Option(help: "The version that you would like to pin your current directory to")
    var version: String?
    
    @Option(help: "Directory path used when pin version. If not specified the current working directory.")
    var path: String?
    
    // MARK: - Initialization
    
    public init() { }
    
    // MARK: - Public Functions
    
    public func run() throws {
        try run(version: version, path: path)
    }
    
    public func run(version: String?, path: String?) throws {
        if let version {
            try VersionsService().pin(version: version, atPath: path)
        } else {
            try printLocalVersions()
        }
    }
    
    // MARK: - Private Functions
    
    private func printLocalVersions() throws {
        let versions = try VersionsService().installedVersions()
        guard !versions.isEmpty else {
            Logger().log("No versions of stellar are installed yet")
            return
        }
        
        Logger().log("The following versions are available in the local environment:")
        let output = versions.reversed().map { "- \($0)" }.joined(separator: "\n")
        Logger().log("\n\(output)")
    }
    
}
