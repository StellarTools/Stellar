// TestAction.swift

import ArgumentParser
import Foundation

@main
struct TestAction: AsyncParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "A utility to perform common test tasks via xcodebuild and swift.",
        subcommands: [
            GenericTestCommand.self
        ])
}
