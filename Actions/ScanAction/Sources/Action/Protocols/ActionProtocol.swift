//  ActionProtocol.swift

import Foundation

// Define the protocol for an action.
public protocol ActionProtocol {
    associatedtype Configuration: ActionConfigurationProtocol
    
    // What's the configuration object used to configure this action.
    static var configType: Configuration.Type { get set }
    
    func run(config: Configuration) throws
    
}

extension ActionProtocol {
    
    // Helper to print all the properties defined into the action's configuration!
    public static func actionOptions() -> [ActionOptionProtocol] {
        configType.init().options()
    }
    
    /*public static func newOptions() -> Configuration {
        configType.init()
    }*/
    
}
