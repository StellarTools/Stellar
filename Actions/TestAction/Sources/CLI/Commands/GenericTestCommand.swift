//  GenericTestCommand.swift

import ArgumentParser
import Foundation
import TestAction

struct GenericTestCommand: AsyncParsableCommand {
    
    @Option(name: .long, help: "The scheme to use.")
    var scheme: String
    
    @Option(name: .long, help: "The name of the simulator to use.")
    var simulatorName: String?
    
    @Option(name: .long, help: "The version of the OS to use.")
    var osVersion: String?
    
    @Option(name: .long, help: "The platform to use.")
    var platform: Platform
    
    @Option(name: .long, help: "The path to the workspace or project.")
    var path: String = "./"
    
    static var configuration = CommandConfiguration(
        commandName: "run-tests",
        abstract: "Command to run tests."
    )
    
    func run() async throws {
        try TestsRunner.runTests(scheme: scheme,
                                 platform: platform,
                                 osVersion: osVersion,
                                 simulatorName: simulatorName,
                                 path: path)
    }
}
