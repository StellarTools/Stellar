//  Array+EscapedAndJoined.swift

import Foundation

extension [String] {

    func escapedAndJoined(separator: String = " ") -> String {
        self
            .map { $0.spm_shellEscaped() }
            .joined(separator: separator)
    }
}
