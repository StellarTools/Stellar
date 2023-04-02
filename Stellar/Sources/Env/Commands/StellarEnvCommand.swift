//  StellarEnvCommand.swift

import ArgumentParser
import Foundation
import StellarCore

struct StellarEnvCommand: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "stellar",
            abstract: "Manage multiple stellar versions.",
            subcommands: [
                BundleCommand.self,
                InstallCommand.self,
                InstalledCommand.self,
                ListCommand.self,
                PinCommand.self,
                UpdateCommand.self
            ]
        )
    }
    
    // MARK: - Methods
    
    static func main(arguments: [String]) {
        let cmdsList = Array(arguments.dropFirst())
        
        // Help env
        if cmdsList.first == "--help-env" {
            let error = CleanExit.helpRequest(self)
            exit(withError: error)
        }
        
        // PARSE RECEIVED COMMAND
        // Check if the command (along with its args) is one of the commands
        // exposed by `stellarenv` (this) or should be redirect to one of the `stellar` cli
        // versions installed at `~/.stellar`.
        var command: ParsableCommand?
        do {
            command = try suitableEnvCommand(arguments: cmdsList)
        } catch {
            let exitCode = exitCode(for: error).rawValue
            if exitCode == 0 {
                Logger.info?.write(fullMessage(for: error))
            } else {
                Logger.error?.write(fullMessage(for: error))
            }
            _exit(exitCode)
        }
        
        // EXECUTE OR FORWARD COMMAND
        // If parsed command is not a stellar command (`command == nil`) we
        // call `stellar` CLI tool with the same arguments.
        do {
            if var command {
                Logger.debug?.write("Commands will be executed by StellarEnv")
                try command.run()
                return
            }
            
            try CLICommandResolver().run(args: cmdsList)
            _exit(0)
        } catch { // Exit cleanly
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
    private static func suitableEnvCommand(arguments: [String]) throws -> ParsableCommand? {
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
