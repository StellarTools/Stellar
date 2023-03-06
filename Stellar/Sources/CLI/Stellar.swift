//  Stellar.swift

import ArgumentParser
import Foundation
import StellarCore

@main
struct Stellar: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Manage the infrastructure that allows the execution of common Swift projects tasks.",
        subcommands: [
            BuildCommand.self,
            CreateActionCommand.self,
            CreateTaskCommand.self,
            EditCommand.self,
            InitCommand.self,
            VersionCommand.self
        ]
    )
}

