import ArgumentParser
import Foundation
import Stellar

struct EnvCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "stellar",
        abstract: "Manage stellar versions",
        subcommands: [
            LocalCommand.self,
            ListCommand.self,
            InstallCommand.self,
            UpdateCommand.self
        ]
    )
    
    public static func main() {
        let processedArguments = processArguments()

        // Help env
        if processedArguments.dropFirst().first == "--help-env" {
            let error = CleanExit.helpRequest(self)
            exit(withError: error)
        }
        
        // Parse the command
        var command: ParsableCommand?
        do {
            if let parsedArguments = try parse() {
                command = try parseAsRoot(parsedArguments)
            }
        } catch {
            let exitCode = exitCode(for: error).rawValue
            if exitCode == 0 {
                Logger().log("\(fullMessage(for: error))")
            } else {
                Logger().log("\(fullMessage(for: error))")
            }
            _exit(exitCode)
        }
        
        do {
            if var command = command {
                try command.run()
            } else {
                try CommandRunner().run()
            }
            _exit(0)
        } catch {
            // Exit cleanly
            if exitCode(for: error).rawValue == 0 {
                exit(withError: error)
            } else {
                _exit(exitCode(for: error).rawValue)
            }
        }
        
    }
    
    private static func parse() throws -> [String]? {
        let arguments = Array(processArguments().dropFirst())
        guard let firstArgument = arguments.first else { return nil }
        // swiftformat:disable preferKeyPath
        let containsCommand = configuration.subcommands.map { $0.configuration.commandName }.contains(firstArgument)
        // swiftformat:enable preferKeyPath
        if containsCommand {
            return arguments
        }
        return nil
    }
    
    static func processArguments() -> [String] {
        CommandRunner.arguments()
    }
    
}

