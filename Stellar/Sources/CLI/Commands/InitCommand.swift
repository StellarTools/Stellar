//  InitCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct InitCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var appPath: String = "./"
    
    @Option(name: .shortAndLong, help: "")
    private var templates: String?
    
    func run() throws {
        let appLocation = URL(fileURLWithPath: appPath)
        let executorTemplatesLocation = TemplatesLocationFactory(templatesPath: templates).executorTemplatesLocation
        try Initializer().install(at: appLocation, templatesLocation: executorTemplatesLocation)
    }
}
