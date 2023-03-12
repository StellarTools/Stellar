//  ListCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct ListCommand: ParsableCommand {
    
    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "list",
            abstract: "List the released versions of stellar."
        )
    }
    
    // MARK: - Options
        
    @Flag(help: "Include pre-release versions in the list.")
    public var preReleases: Bool = false
    
    // MARK: - Functions

    public func run() throws {
        try run(includePreRelease: preReleases)
    }
    
    // MARK: - Private Functions
    
    public func run(includePreRelease preRelease: Bool) throws {
        let versionsProvider = ReleaseProvider()
        
        let latestReleases = try versionsProvider.availableReleases(preReleases: preRelease)
        guard !latestReleases.isEmpty else {
            Logger().log("Failed to evaluate remote releases on stellar project")
            return
        }
            
        Logger().log("Latest \(latestReleases.count) release found:")
        latestReleases.forEach {
            Logger().log("  - \($0.tagName) \($0.preRelease ? "[pre-release]" : "")".trimmingCharacters(in: .whitespaces))
        }
    }
    
}
