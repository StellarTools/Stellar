//  InitCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct InitCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initialise the infrastructure for a Swift project."
    )
    
    // MARK: - Options
    
    @Flag(help: "Enable verbose logging.")
    var verbose: Bool = false
    
    @Option(name: .shortAndLong, help: "The path to the project. Optional, defaults to the current directory.")
    private var projectPath: String = "./"
    
    @Option(name: .shortAndLong, help: "The path to the templates. Optional, defaults to the templates shipped with the release.")
    private var templatesPath: String?
    
    // MARK: - Methods
    
    func run() throws {
        Logger.verbose = verbose

        let projectUrl = URL(fileURLWithPath: projectPath)
        let executorTemplatesLocation = TemplatesLocationFactory(templatesPath: templatesPath).executorTemplatesLocation
        try Initializer().install(at: projectUrl, templatesLocation: executorTemplatesLocation)
    }
}
