//  ActionParam.swift

import Foundation

/// A single option to configure an action parameter.
public protocol ActionOptionProtocol {
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

@propertyWrapper public class ActionParam: ActionOptionProtocol, Decodable {
    
    public let environment: String?
    public let defaultValue: String?
    public var wrappedValue: String?
    public var isRequired: Bool
    public var name: String?
    
    public init(environment: String? = nil, defaultValue: String? = nil, required: Bool = false) {
        self.defaultValue = defaultValue
        self.environment = environment
        self.isRequired = required
    }
}

