//  ParsableCommand+RecognizedSubcommand.swift

import ArgumentParser
import Foundation

extension ParsableCommand {

    /// A `ParsableCommand` instance representing a subcommand if the arguments can execute a subcommand, nil otherwise.
    /// - Parameter arguments: List of arguments starting with the command.
    /// - Returns: A `ParsableCommand` instance.
    static func recognizedParsableCommand(for arguments: [String]) throws -> ParsableCommand? {
        guard
            let firstArgument = arguments.first,
            isCommandRecognizedAsSubcommand(firstArgument)
        else {
            return nil
        }
        return try parseAsRoot(arguments)
    }

    private static func isCommandRecognizedAsSubcommand(_ command: String) -> Bool {
        configuration.subcommands.map {
            $0.configuration.commandName
        }.contains(command)
    }
}
