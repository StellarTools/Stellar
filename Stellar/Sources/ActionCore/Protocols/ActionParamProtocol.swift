//  ActionParamProtocol.swift

import Foundation

/// A single option to configure an action parameter.
public protocol ActionParamProtocol {
    // Environment variable name (used to pass variables across actions)
    var environment: String? { get }
    // The default value of the option
    var defaultValue: String? { get }
    // Value.
    var wrappedValue: String? { get set }
    // Is this required for lane.
    var isRequired: Bool { get }
    // Name of the variable (set automatically)
    var name: String? { get set }
}


