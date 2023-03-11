import ArgumentParser
import Foundation
import StellarCore

struct StellarEnvCommand: ParsableCommand {
    
    public static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "stellar",
            abstract: "Manage multiple stellar versions.",
            subcommands: [
                LocalCommand.self,
                ListCommand.self,
                CLIInstallCommand.self,
                UpdateCommand.self,
                BundleCommand.self
            ]
        )
    }
    
    // MARK: - Initialization
    
    public init() {
        
    }
    
    // MARK: - Public Functions
    
    public static func main(_: [String]? = nil) {
        let cmdsList = commandArguments().dropFirst()
        if cmdsList.isEmpty {
            _exit(0)
        }
        
        // PARSE RECEIVED COMMAND
        // Check if the command (along with its args) is one of the commands
        // exposed by `stellarenv` (this) or should be redirect to one of the `stellar` cli
        // versions installed at `~/.stellar`.
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
        // If parsed command is not a stellar command (`command == nil`) we
        // call `stellar` CLI tool with the same arguments.
        do {
            if var command {
                Logger().log("Commands will be executed by stellarenv")
                try command.run()
                return
            }
            
            try CommandResolver().run(args: Array(commandArguments().dropFirst()))
            _exit(0)
        } catch { // Exit cleanly
            if exitCode(for: error).rawValue == 0 {
                exit(withError: error)
            } else {
                Logger().log("Exited with error: \(error.localizedDescription)")
                _exit(exitCode(for: error).rawValue)
            }
        }
    }
    
    // MARK: - Private Functions
    
    /// Check if the received command is one of the command available in `stellarenv`.
    /// In this case return the appropriate `ParsableCommand` instance to execute.
    ///
    /// If the result is `nil`, the command is probably one of the commands available
    /// in `stellar` cli tool.
    ///
    /// - Returns: `stellarenv` parsable command, if available.
    private static func suitableEnvCommand() throws -> ParsableCommand? {
        guard let parsedArguments = try parseCommands() else {
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
