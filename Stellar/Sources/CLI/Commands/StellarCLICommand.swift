//  StellarCLICommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct StellarCLICommand: ParsableCommand {

    static var configuration: CommandConfiguration {
        CommandConfiguration(
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

    // MARK: - Methods

    static func main(arguments: [String]) {
        let cmdsList = Array(arguments.dropFirst())

        // Help env
        if cmdsList.first == "--help" {
            let error = CleanExit.helpRequest(self)
            exit(withError: error)
        }

        // Parse received arguments
        var command: ParsableCommand?
        do {
            command = try suitableCLICommand(arguments: cmdsList)
        } catch {
            let exitCode = exitCode(for: error).rawValue
            if exitCode == 0 {
                Logger.info?.write(fullMessage(for: error))
            } else {
                Logger.error?.write(fullMessage(for: error))
            }
            _exit(exitCode)
        }

        do {
            if var command {
                Logger.debug?.write("Commands will be executed by Executor")
                try command.run()
                return
            }

            _exit(0)
        } catch {
            // Exit cleanly
            if exitCode(for: error).rawValue == 0 {
                exit(withError: error)
            } else {
                Logger.error?.write("Exited with error: \(error.localizedDescription)")
                _exit(exitCode(for: error).rawValue)
            }
        }
    }

    // MARK: - Private Methods

    /// Check if the received command is one of the command available in `stellarenv`.
    /// In this case return the appropriate `ParsableCommand` instance to execute.
    ///
    /// If the result is `nil`, the command is probably one of the commands available
    /// in `stellar` cli tool.
    ///
    /// - Returns: `stellarenv` parsable command, if available.
    private static func suitableCLICommand(arguments: [String]) throws -> ParsableCommand? {
        guard let parsedArguments = try parseCommands(arguments: arguments) else {
            return nil
        }

        return try parseAsRoot(parsedArguments)
    }

    private static func parseCommands(arguments: [String]) throws -> [String]? {
        guard let firstArgument = arguments.first else {
            return nil // no arguments provided.
        }

        // Is the invoked command one of the commands of the `stellarenv` tool?
        let containsCommand = configuration.subcommands.map {
            $0.configuration.commandName
        }.contains(firstArgument)

        return (containsCommand ? arguments : nil)
    }

}
