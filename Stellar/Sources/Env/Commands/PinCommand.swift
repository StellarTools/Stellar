//  PinCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct PinCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "pin",
        abstract: "Create a .stellar-version file to pin stellar to a specific version at a given path."
    )
    
    // MARK: - Options

    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    @Option(help: "The version that you would like to pin to.")
    var version: String
    
    @Option(help: "Directory path used when pinning the version. Optional, defaults to the current directory. (default: ./)")
    var path: String?
    
    // MARK: - Methods
    
    func run() throws {
        Logger.verbose = verbose
        try pin(path: path, toVersion: version)
    }
    
    // MARK: - Private Methods
    
    /// Pin project at `path` to a specified version of stellar.
    ///
    /// - Parameters:
    ///   - path: path of the project.
    ///   - version: version to pin.
    private func pin(path: String?, toVersion version: String) throws {
        let urlPath = (path != nil ? URL(fileURLWithPath: path!) : nil)
        try CLIService().pin(url: urlPath, toVersion: version)
    }
    
}
