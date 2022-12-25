//  EditCommand.swift

import ArgumentParser
import Foundation
import Stellar

struct EditCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "edit",
        abstract: "Abstract")
    
    @Option(name: .long, help: "")
    private var path: String = "./"
    
    func run() throws {
        let location = URL(fileURLWithPath: path)
        try Editor().edit(at: location)
    }
}

