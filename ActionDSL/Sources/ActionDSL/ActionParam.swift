//  ActionParam.swift

import Foundation

@propertyWrapper
public class ActionParam: ActionParamProtocol, Decodable {
    
    public var wrappedValue: String?
    public var propertyName: String?
    public let defaultValue: String?
    public var isRequired: Bool
    
    public init(defaultValue: String? = nil, required: Bool = false) {
        self.defaultValue = defaultValue
        self.isRequired = required
    }
}

