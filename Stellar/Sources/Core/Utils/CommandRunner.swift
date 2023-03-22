//  CommandRunner.swift

import Foundation
import TSCBasic

public final class CommandRunner {

    // MARK: - Public Functions

    /// Run a command.
    ///
    /// - Parameters:
    ///   - arguments: command arguments.
    ///   - environment: environment variables.
    ///   - redirection: redirection policy.
    ///   - sudoOnFailure: retry the command using sudoif fails. Default to `false`.
    /// - Returns: the output of the command.
    @discardableResult
    static public func run(
        _ arguments: [String],
        environment: [String: String]? = nil,
        redirection: TSCBasic.Process.OutputRedirection? = nil,
        sudoIfNeeded: Bool = false
    ) throws -> String {
        let environment = environment ?? ProcessInfo.processInfo.environment
        let redirection = redirection ?? Process.OutputRedirection.stream(stdout: { bytes in
            FileHandle.standardOutput.write(Data(bytes))
        }, stderr: { bytes in
            FileHandle.standardError.write(Data(bytes))
        })
        do {
            return try run(arguments,
                           environment: environment,
                           redirection: redirection)
        } catch {
            guard sudoIfNeeded else  {
                throw error
            }
            return try run(["sudo"] + arguments,
                           environment: environment,
                           redirection: redirection)
        }
    }

    // MARK: - Private Functions
    
    static private func run(
        _ arguments: [String],
        environment: [String: String],
        redirection: TSCBasic.Process.OutputRedirection
    ) throws -> String {
        let process = Process(
            arguments: arguments,
            environment: environment,
            outputRedirection: redirection,
            startNewProcessGroup: false
        )
        try process.launch()
        let result = try process.waitUntilExit()
        try result.throwIfErrored()
        return try result.utf8Output()
    }
}
