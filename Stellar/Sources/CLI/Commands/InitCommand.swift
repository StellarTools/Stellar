//  InitCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct InitCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initialise the infrastructure for a Swift project.")
    
    @Option(name: .shortAndLong, help: "The path to the project. Optional, defaults to the current directory.")
    private var projectPath: String = "./"
    
    @Option(name: .shortAndLong, help: "The path to a Templates.bundle. Optional, defaults to the templates shipped with the release.")
    private var templates: String?
    
    func run() throws {
        let appLocation = URL(fileURLWithPath: projectPath)
        let executorTemplatesLocation = TemplatesLocationFactory(templatesPath: templates).executorTemplatesLocation
        try Initializer().install(at: appLocation, templatesLocation: executorTemplatesLocation)
    }
}
