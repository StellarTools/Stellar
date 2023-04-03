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

    static let fileManager = FileManager.default

    // MARK: - Methods

    static func main(args: [String]) throws {
        let arguments = Array(args.dropFirst())

        // Help env
        if arguments.first == "--help" {
            let error = CleanExit.helpRequest(self)
            exit(withError: error)
        }

        // Parse received arguments
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

        do {
            if var command {
                Logger.debug?.write("Commands will be executed by StellarCLI")
                try command.run()
                return
            }

            // Forward the arguments to the executor
            if arguments.first == "exec" {
                try callExecutor(using: Array(arguments.dropFirst()))
            }
            else {
                throw ValidationError("Invalid involcation.")
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

    /// Call the Executor passing the list of provided arguments.
    /// If the `--project-path` argument is in the list, the value is used to execute the Executor from the defined path
    /// and it and its value are removed when executing the Executor.
    /// and
    /// - Parameter arguments: List of arguments starting with the command.
    private static func callExecutor(using arguments: [String]) throws {
        if let index = arguments.firstIndex(of: "--project-path") {
            if arguments.count > index + 1 {
                let projectUrl = URL(fileURLWithPath: arguments[index + 1])
                var executorArguments = arguments
                executorArguments.removeSubrange(index...index + 1)
                let executorInvoker = ExecutorInvoker(projectUrl: projectUrl)
                try executorInvoker.run(args: executorArguments)
            }
            else {
                throw ValidationError("No project path provided.")
            }
        } else {
            let executorRunner = ExecutorInvoker(projectUrl: fileManager.currentLocation)
            try executorRunner.run(args: arguments)
        }
    }

}
