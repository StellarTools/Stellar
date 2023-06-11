//  ActionConfigurationProtocol.swift

import Foundation

public protocol ActionConfigurationProtocol: Decodable {
    init()
    func options() -> [ActionParamProtocol]
}

extension ActionConfigurationProtocol {
    
    public func options() -> [ActionParamProtocol] {
        let dummyInstance =  Self.init()
        let mirror = Mirror(reflecting: dummyInstance)
        
        let properties: [ActionParamProtocol] = mirror.children.compactMap { (label, value) in
            guard var property = value as? ActionParamProtocol else {
                return nil
            }
            property.propertyName = label?.trimmingCharacters(in: .init(charactersIn: "_"))
            return property
        }
        return properties
    }
}
