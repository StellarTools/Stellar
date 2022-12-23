//  SampleTask.swift

import ArgumentParser
import Foundation
import SampleAction

struct SampleTask: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sample",
        abstract: "Abstract")
    
    @Argument(help: "A phrase.")
    var phrase: String
    
    @Flag(help: "Enable verbose logging.")
    var verbose = false
    
    @Option(name: .shortAndLong, help: "The number of times to invoke `call` on `SampleAction`.")
    var count: Int = 1
    
    func run() async throws {
        if verbose {
            print("[SampleTask] verbose log.")
        }
        
        for _ in 0..<count {
            let task = SampleAction(argument: phrase)
            task.call()
        }
    }
}
