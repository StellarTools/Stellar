//  EditCommand.swift

import ArgumentParser
import Foundation
import ShellOut
import Stellar

struct EditCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "edit",
        abstract: "Abstract")
    
    @Option(name: .long, help: "")
    private var path: String = "./"
    
    func run() throws {
        guard let url = URL(string: path) else {
            throw ValidationError("Invalid path '\(path)'.")
        }
        
        let executorUrl = url
            .appendingPathComponent(Constants.stellar, isDirectory: true)
            .appendingPathComponent(Constants.executor, isDirectory: true)
        
        do {
            try shellOut(to: "xed",
                         arguments: [executorUrl.path],
                         outputHandle: .standardOutput,
                         errorHandle: .standardError)
        } catch {
            Logger.log("No package '\(Constants.executor)' found at \(executorUrl.path).")
        }
    }
}

