//  ActionConfigurationProtocol.swift

import Foundation

/// A collection of options used to configure an action.
public protocol ActionConfigurationProtocol: Decodable {
    
    init()

    func options() -> [ActionOptionProtocol]

}

extension ActionConfigurationProtocol {
    
    public func options() -> [ActionOptionProtocol] {
        let dummyInstance =  Self.init()
        let mirror = Mirror(reflecting: dummyInstance)
        
        let properties: [ActionOptionProtocol] = mirror.children.compactMap { (label, value) in
            guard var property = value as? ActionOptionProtocol else {
                return nil
            }
            property.name = label?.trimmingCharacters(in: .init(charactersIn: "_"))
            return property
        }
        return properties
    }
    
}
