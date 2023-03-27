//  ProcessResult+Throwing.swift

import Foundation
import TSCBasic

extension ProcessResult {
    
    /// Throws an error if the command exited with non zero exit code.
    ///
    /// - Throws: A wrapped error.
    func throwIfErrored() throws {
        switch exitStatus {
        case let .signalled(code):
            let data = Data(try stderrOutput.get())
            throw ShellError.signalled(command: command(),
                                       code: code,
                                       standardError: data)
        case let .terminated(code):
            if code != 0 {
                let data = Data(try stderrOutput.get())
                throw ShellError.terminated(command: command(),
                                            code: code,
                                            standardError: data)
            }
        }
    }
    
    /// The command executed by the process.
    ///
    /// - Returns: the command executed by the process.
    private func command() -> String {
        arguments.escapedAndJoined()
    }
}
