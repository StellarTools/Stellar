//  Stellar.swift

import ArgumentParser
import Foundation
import Stellar

@main
struct Stellar: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Abstract",
        subcommands: [
            BuildCommand.self,
            CreateActionCommand.self,
            EditCommand.self,
            InitCommand.self
        ]
    )
}

