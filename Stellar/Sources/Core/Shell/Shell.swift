//  Shell.swift

import Foundation
import TSCBasic

public final class Shell {

    /// Convenience shortcut to the environment.
    static private var defaultEnvironment: [String: String] {
        ProcessInfo.processInfo.environment
    }
    
    // MARK: - Public Functions

    /// Run a command.
    ///
    /// - Parameters:
    ///   - arguments: the command arguments.
    ///   - workingDirectory: the directory in which to run the command.
    static public func run(
        _ arguments: [String],
        workingDirectory: String? = nil
    ) throws {
        let workingDirectory = workingDirectory ?? FileManager.default.currentDirectoryPath
        try run(arguments,
                environment: defaultEnvironment,
                workingDirectory: workingDirectory,
                redirection: .stream(stdout: { bytes in
            FileHandle.standardOutput.write(Data(bytes))
        }, stderr: { bytes in
            FileHandle.standardError.write(Data(bytes))
        }))
    }

    /// Run a command collecting stdout and stderr in the result.
    ///
    /// - Parameters:
    ///   - arguments: command arguments.
    ///   - workingDirectory: the directory in which to run the command.
    /// - Returns: stdout and stderr of the command.
    static public func runAndCollect(
        _ arguments: [String],
        workingDirectory: String? = nil
    ) throws -> String {
        let workingDirectory = workingDirectory ?? FileManager.default.currentDirectoryPath
        return try run(arguments,
                       environment: defaultEnvironment,
                       workingDirectory: workingDirectory,
                       redirection: .collect)
    }
    
    // MARK: - Private Functions

    @discardableResult
    static private func run(
        _ arguments: [String],
        environment: [String: String],
        workingDirectory: String,
        redirection: TSCBasic.Process.OutputRedirection
    ) throws -> String {
        let process = Process(
            arguments: arguments,
            environment: environment,
            workingDirectory: try AbsolutePath(validating: workingDirectory),
            outputRedirection: redirection,
            startNewProcessGroup: false
        )
        try process.launch()
        let result = try process.waitUntilExit()
        try result.throwIfErrored()
        return try result.utf8Output().cleanShellOutput()
    }
}
