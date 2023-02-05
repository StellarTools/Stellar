import ArgumentParser
import Foundation
import Stellar

public struct ListCommand: AsyncParsableCommand {
    
    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "list",
            abstract: "List remote versions of stellar"
        )
    }
        
    @Flag(help: "When no version is specified include pre-releases in list")
    public var preRelease: Bool = false
    
    // MARK: - Initialization
    
    public init() { }
    
    // MARK: - Public Functions

    public func run() async throws {
        try await run(preRelease: preRelease)
    }
    
    public func run(preRelease: Bool) async throws {
        let manager = InstallManager()
        
        let latestReleases = try await manager.remoteVersions(includePreReleases: preRelease)
        guard !latestReleases.isEmpty else {
            Logger().log("Failed to evaluate remote releases on stellar project")
            return
        }
            
        Logger().log("Latest \(latestReleases.count) release found:")
        latestReleases.forEach {
            Logger().log("  - \($0.tag_name) \($0.prerelease ? "[pre-release]" : "")".trimmingCharacters(in: .whitespaces))
        }
    }
    
}
