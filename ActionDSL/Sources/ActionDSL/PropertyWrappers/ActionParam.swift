//  ActionParam.swift

import Foundation

@propertyWrapper public class ActionParam: ActionParamProtocol, Decodable {

    public var environment: String?
    public let defaultValue: String?
    public var isRequired: Bool
    public var propertyName: String?

    public init(environment: String? = nil,
                defaultValue: String? = nil,
                propertyName: String? = nil,
                isRequired: Bool = false) {
        self.environment = environment
        self.defaultValue = defaultValue
        self.propertyName = propertyName
        self.isRequired = isRequired
    }

    public var wrappedValue: String? {
        didSet {
            if let environment {
                EnvironmentManager.shared.addVariable(wrappedValue ?? "", for: environment)
            }
        }
    }
}
