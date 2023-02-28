import Foundation
import TSCBasic

/// Access to system commands.
public final class Shell {
    
    // MARK: - Public Properties
    
    /// Singleton instance of the system.
    public static var shared = Shell()
    
    /// Convenience shortcut to the environment.
    public var env: [String: String] {
        ProcessInfo.processInfo.environment
    }
    
    // MARK: - Public Functions
    
    public func runAndPrint(_ arguments: [String], environment: [String: String]? = nil) throws {
        try runAndPrint(arguments, environment: environment ?? env, redirection: .none)
    }
    
    /// Run system command.
    ///
    /// - Parameters:
    ///   - arguments: arguments to try.
    ///   - sudoIfNeeded: `true` to also try the same command sudoing if fails.
    public func run(_ arguments: [String], sudoIfNeeded: Bool = false) throws {
        do {
            _ = try capture(arguments)
        } catch {
            guard sudoIfNeeded else {
                throw error
            }
            _ = try capture(["sudo"] + arguments)
        }
    }
    
    /// Download the file at given url.
    ///
    /// - Parameters:
    ///   - url: url to download.
    ///   - fileURL: destination of the file.
    public func file(url: URL, at fileURL: URL) throws {
        try run(["/usr/bin/curl", "-LSs", "--output", fileURL.path, url.absoluteString])
    }
    
    /// Unzip file at given local URL.
    ///
    /// - Parameters:
    ///   - fileURL: local URL of the zip file.
    ///   - name: name of file/folder(s).
    ///   - destinationURL: destination location.
    public func unzip(fileURL: URL, name: String? = nil, destinationURL: URL) throws {
        try run(["/usr/bin/unzip", "-q", fileURL.path, name, "-d", destinationURL.path].compactMap({ $0 }))
    }
    
    /// Copy and replace (if needed) a file at given position.
    ///
    /// - Parameters:
    ///   - sourceURL: source file.
    ///   - destination: destination location.
    public func copyAndReplace(source: URL, destination: String) throws {
        try Shell.shared.run(["rm", "-f", destination], sudoIfNeeded: true)
        try Shell.shared.run(["mv", source.path, destination], sudoIfNeeded: true)
    }

    /// Execute which with given target name.
    ///
    /// - Parameter name: name of the CLI tool to found.
    /// - Returns: path, if found.
    public func which(_ name: String) throws -> String {
        try capture(["/usr/bin/env", "which", name]).cleanShellOutput()
    }
    
    // MARK: - Private Functions
    
    /// Run the command and redirect the output.
    ///
    /// - Parameters:
    ///   - arguments: arguments to call.
    ///   - environment: environment variables.
    ///   - redirection: redirection model.
    private func runAndPrint(_ arguments: [String], environment: [String: String], redirection: TSCBasic.Process.OutputRedirection) throws {
        let process = Process(
            arguments: arguments,
            environment: environment,
            outputRedirection: .stream(stdout: { bytes in
                FileHandle.standardOutput.write(Data(bytes))
                redirection.outputClosures?.stdoutClosure(bytes)
            }, stderr: { bytes in
                FileHandle.standardError.write(Data(bytes))
                redirection.outputClosures?.stderrClosure(bytes)
            }),
            startNewProcessGroup: false
        )

        Logger().log("\(escaped(arguments: arguments))")

        try process.launch()
        let result = try process.waitUntilExit()
        let output = try result.utf8Output()

        Logger().log("\(output)")

        try result.throwIfErrored()
    }

    private func capture(_ arguments: [String]) throws -> String {
        try capture(arguments, environment: env)
    }

    private func capture(_ arguments: [String], environment: [String: String]) throws -> String {
        let process = Process(
            arguments: arguments,
            environment: environment,
            outputRedirection: .collect,
            startNewProcessGroup: false
        )

        Logger().log("\(escaped(arguments: arguments))")

        try process.launch()
        let result = try process.waitUntilExit()
        let output = try result.utf8Output()

        Logger().log("\(output)")

        try result.throwIfErrored()

        return try result.utf8Output()
    }
        
    private func escaped(arguments: [String]) -> String {
        arguments.map { $0.spm_shellEscaped() }.joined(separator: " ")
    }

}

// MARK: - ProcessResult Extension

private extension ProcessResult {
    
    /// Throws a SystemError if the result is unsuccessful.
    ///
    /// - Throws: A SystemError.
    func throwIfErrored() throws {
        switch exitStatus {
        case let .signalled(code):
            let data = Data(try stderrOutput.get())
            throw ShellError.signalled(command: command(), code: code, standardError: data)
        case let .terminated(code):
            if code != 0 {
                let data = Data(try stderrOutput.get())
                throw ShellError.terminated(command: command(), code: code, standardError: data)
            }
        }
    }

    /// It returns the command that the process executed.
    /// If the command is executed through xcrun, then the name of the tool is returned instead.
    /// - Returns: Returns the command that the process executed.
    func command() -> String {
        let command = arguments.first!
        if command == "/usr/bin/xcrun" {
            return arguments[1]
        }
        return command
    }
}

// MARK: - SystemError

public enum ShellError: Error, Equatable {
    case terminated(command: String, code: Int32, standardError: Data)
    case signalled(command: String, code: Int32, standardError: Data)
    case parseSwiftVersion(String)
}
