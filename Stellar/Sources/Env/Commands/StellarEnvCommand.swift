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
                UninstallCommand.self,
                UpdateCommand.self,
                VersionCommand.self
            ]
        )
    }
    
    // MARK: - Methods
    
    static func main(args: [String]) throws {
        let arguments = Array(args.dropFirst())
        
        // Help env
        if arguments.first == "--help-env" {
            let error = CleanExit.helpRequest(self)
            exit(withError: error)
        }
        
        // PARSE RECEIVED COMMAND
        // Check if the command (along with its args) is one of the commands
        // exposed by `stellarenv` (this) or should be redirect to one of the `stellar` cli
        // versions installed at `~/.stellar`.
        var command: ParsableCommand?
        do {
            command = try recognizedParsableCommand(for: arguments)
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
            
            try CLIInvoker().run(args: arguments)
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

}
