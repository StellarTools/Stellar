//  Environment.swift

import Foundation

@propertyWrapper public class Environment: Decodable {
    
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public var wrappedValue: String? {
        EnvironmentManager.shared.resolve(name)
    }
    
}
