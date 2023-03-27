//  InstalledCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct InstalledCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "installed",
        abstract: "Prints the local versions."
    )
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    // MARK: - Methods
    
    func run() throws {
        Logger.verbose = verbose
        try enumerateInstalledVersions()
    }
    
    // MARK: - Private Methods
    
    /// Enumerate the list of the installed versions of stellar.
    private func enumerateInstalledVersions() throws {
        let versions = try VersionResolver().installedVersions()
        guard !versions.isEmpty else {
            Logger.info?.write("No versions of stellar are installed yet")
            return
        }
        
        Logger.info?.write("Installed versions are:")
        let output = versions.reversed().map { "- \($0)" }.joined(separator: "\n")
        Logger.info?.write("\n\(output)")
    }
    
}
