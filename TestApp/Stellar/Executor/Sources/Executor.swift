//  Executor.swift

import ArgumentParser
import Foundation

@main
struct Executor: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Abstract",
        subcommands: [
            SampleTask.self
        ]
    )
}

