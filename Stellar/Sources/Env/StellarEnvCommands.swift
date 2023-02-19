import ArgumentParser
import Foundation
import Stellar

struct StellarEnvCommands: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "stellar",
        abstract: "Manage stellar versions",
        subcommands: [
            LocalCommand.self,
            ListCommand.self,
            CLIInstallCommand.self,
            UpdateCommand.self
        ]
    )
    
    // MARK: - Public Functions
    
    public static func main() {
        // PARSE RECEIVED COMMAND
        // Check if the command (along with its args) is one of the commands
        // exposed by `stellarenv` (this) or should be redirect to one of the `stellar` cli
        // versions installed in `~/.stellar` home directory.
        var command: ParsableCommand?
        do {
            command = try suitableEnvCommand()
        } catch {
            let exitCode = exitCode(for: error).rawValue
            if exitCode == 0 {
                Logger().log("\(fullMessage(for: error))")
            } else {
                Logger().log("[ERROR] \(fullMessage(for: error))")
            }
            _exit(exitCode)
        }
        
        // EXECUTE OR FORWARD COMMAND
        // If parsed command is not a stellar command (`command == nil`) we would
        // to call `stellar` cli tool with the same arguments.
        do {
            if var command {
                try command.run()
                return
            }
            
            try CommandForwarder().run(args: Array(commandArguments().dropFirst()))
            _exit(0)
        } catch { // Exit cleanly
            if exitCode(for: error).rawValue == 0 {
                exit(withError: error)
            } else {
                _exit(exitCode(for: error).rawValue)
            }
        }
    }
    
    // MARK: - Private Functions
    
    /// Check if received command is one of the command available in `stellarenv`.
    /// In this case return the appropriate `ParsableCommand` instance to execute.
    ///
    /// If the result is `nil` command is probably one of the commands available
    /// in `stellar` cli tool.
    ///
    /// - Returns: `stellarenv` parsable command, if available.
    private static func suitableEnvCommand() throws -> ParsableCommand? {
        guard  let parsedArguments = try parseCommands() else {
            return nil
        }
        
        return try parseAsRoot(parsedArguments)
    }
    
    private static func parseCommands() throws -> [String]? {
        let arguments = Array(commandArguments().dropFirst())
        guard let firstArgument = arguments.first else {
            return nil // no arguments provided.
        }

        // Is the invoked command one of the commands of the `stellarenv` tool?
        let containsCommand = configuration.subcommands.map {
            $0.configuration.commandName
        }.contains(firstArgument)

        return (containsCommand ? arguments : nil)
    }
    
    /// Return the list of all arguments used to start the command and remove `--verbose` if set.
    /// 
    /// - Returns: list of args.
    static func commandArguments() -> [String] {
        Array(ProcessInfo.processInfo.arguments).filter { $0 != "--verbose" }
    }
    
}

