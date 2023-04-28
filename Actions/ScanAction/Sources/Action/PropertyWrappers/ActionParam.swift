//  ActionParam.swift

import Foundation

@propertyWrapper public class ActionParam: ActionParamProtocol, Decodable {
    
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