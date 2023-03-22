//  Shell.swift

import Foundation
import TSCBasic

public final class Shell {
    
    // MARK: - Public Functions
    
    /// Run a command.
    ///
    /// - Parameters:
    ///   - arguments: command arguments.
    ///   - environment: environment variables.
    ///   - redirection: redirection policy.
    /// - Returns: the output of the command.
    @discardableResult
    static public func run(
        _ arguments: [String],
        environment: [String: String]? = nil,
        workingDirectory: String? = nil,
        redirection: TSCBasic.Process.OutputRedirection? = nil
    ) throws -> String {
        let environment = environment ?? ProcessInfo.processInfo.environment
        let redirection = redirection ?? Process.OutputRedirection.stream(stdout: { bytes in
            FileHandle.standardOutput.write(Data(bytes))
        }, stderr: { bytes in
            FileHandle.standardError.write(Data(bytes))
        })
        let workingDirectory = workingDirectory ?? FileManager.default.currentDirectoryPath
        return try run(arguments,
                       environment: environment,
                       workingDirectory: workingDirectory,
                       redirection: redirection)
    }
    
    // MARK: - Private Functions
    
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
        return try result.utf8Output()
    }
}
