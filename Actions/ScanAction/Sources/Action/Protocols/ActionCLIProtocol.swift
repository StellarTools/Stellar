//  ActionCLIProtocol.swift

import Foundation
import ArgumentParser

public protocol ActionCLIProtocol: CustomReflectable {
    
    associatedtype Action: ActionProtocol

    static var allConfigurationOptions: [ActionParamProtocol] { get }
    
    var config: Action.Configuration! { get }
}


extension ActionCLIProtocol {
    
    // MARK: - Private Methods
    
    // PART 1:
    // We want to mock the  ArgumentParser  so that it will believe
    // that it contains properties declared in the `Action.Configuration`.
    
    public var customMirror: Mirror {
        // By implementing a custom Mirror, we can mock the  ArgumentParser  which uses Mirror to read the
        // variables declared in the class, such as  @Flag ,  @Option , and so on.
        // At the end of this function, we have created a list of our variables
        // that were directly read from the action configuration.
        var list = [Mirror.Child]()
        for property in Self.allConfigurationOptions {
            let child: Mirror.Child
            let name = property.name!
            // We can make something better here, it's just to test how it works with optional parasmeters.
            if property.isRequired {
                child = Mirror.Child(label: name, value: Option<String>(name: .shortAndLong))
            } else {
                child = Mirror.Child(label: name, value: Option<Optional<String>>(name: .shortAndLong))
            }
            list.append(child)
        }
        
        return Mirror(Action(), children: list)
    }
    

    

}
