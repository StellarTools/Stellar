//  ListCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct ListCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "list",
            abstract: "List the released versions of stellar."
        )
    }
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
        
    @Flag(help: "Include pre-release versions in the list.")
    var preReleases: Bool = false
    
    // MARK: - Methods

    func run() throws {
        Logger.verbose = verbose
        try run(includePreRelease: preReleases)
    }
    
    // MARK: - Private Methods
    
    private func run(includePreRelease preRelease: Bool) throws {
        let versionsProvider = ReleaseProvider()
        
        let latestReleases = try versionsProvider.availableReleases(preReleases: preRelease)
        guard !latestReleases.isEmpty else {
            Logger.warning?.write("Failed to evaluate remote releases on stellar project")
            return
        }
            
        Logger.info?.write("Latest \(latestReleases.count) release found:")
        latestReleases.forEach {
            Logger.info?.write("  - \($0.tagName) \($0.preRelease ? "[pre-release]" : "")".trimmingCharacters(in: .whitespaces))
        }
    }
    
}
