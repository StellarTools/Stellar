//  InitCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct InitCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var appPath: String = "./"
    
    @Option(name: .shortAndLong, help: "")
    private var templates: String?
    
    func run() throws {
        // create .stellar/Packages/Executor folder
        // create Executor package
        let appLocation = URL(fileURLWithPath: appPath)
        let templatesLocation = templatesLocation(templates)
        try Initializer().install(at: appLocation, templatesLocation: templatesLocation)
    }
}

