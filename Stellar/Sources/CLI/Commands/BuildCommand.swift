//  BuildCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct BuildCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var appPath: String = "./"
    
    func run() throws {
        let location = URL(fileURLWithPath: appPath)
        try Builder().build(at: location)
    }
}

