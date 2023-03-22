//  ShellError.swift

import Foundation

enum ShellError: Error, Equatable {
    case signalled(command: String, code: Int32, standardError: Data)
    case terminated(command: String, code: Int32, standardError: Data)
}
