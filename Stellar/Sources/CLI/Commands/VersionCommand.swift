//  VersionCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct VersionCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "version",
        abstract: "Output the current version of the tool.")
    
    func run() throws {
        try VersionService().run()
    }
}