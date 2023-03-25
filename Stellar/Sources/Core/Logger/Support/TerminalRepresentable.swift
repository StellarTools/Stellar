// TerminalRepresentable.swift

import Foundation

// MARK: - TerminalRepresentable

/// Represent the output visible on terminal.
public protocol TerminalRepresentable {
    
    var stringValue: String { get }
    
}

// MARK: - Default Conformances to TerminalRepresentable

extension TerminalRepresentable where Self: CustomStringConvertible {
    
    public var stringValue: String {
        String(describing: self)
    }
    
}

extension String: TerminalRepresentable {
    
    public var stringValue: String {
        self
    }
    
}
