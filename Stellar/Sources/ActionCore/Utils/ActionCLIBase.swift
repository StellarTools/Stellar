//  ActionCLIBase.swift

import Foundation
import ArgumentParser

open class ActionCLIBase<A: ActionProtocol>: ParsableCommand, ActionCLIProtocol {
    
    public typealias Action = A

    // MARK: - Private Properties
    
    private(set) public var allConfigurationOptions = Action.actionOptions()
    
    // This configuration contains all configuration parameters of the action
    // read directly from the command line interface.
    private(set) public var config: Action.Configuration!
    
    // MARK: - Public Properties
    
    // NOTE:
    // As you can see, we didn't specify any arguments on the `ParsableCommand`  instance.
    // Instead, the values are automatically read from the `Action.Configuration`
    // object and placed into the  `config` variable .
    // All these stuff are executed before `run()` method.
    // At the end `run()` is cal automatically the action specified with the configuration read.
    
    /// Required by ParsableCommand
    required public init() { }
    
    // MARK: - Run
    
    public func run() throws {
        let action = Action()
        // Put a breakpoint here! you will see all the variables passed from the configuration.
        try action.run(config: config)
    }
    
    // PART 2:
    // Since Argument Parser read values of the command line directly from Codable interface
    // we'll parse these values and assign via Mirror to our `config`'s `wrappedValue`.
    // Et voilà!
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var parsedAttributes = [String: String]()
        try self.allConfigurationOptions.forEach { option in
            if let name = option.name {
                let value: String
                if option.isRequired == false {
                    // This extra check is needed to continue in case of non-required optional value.
                    // Yeah, we should handle better these cases but it's just a test!
                    value = try container.decodeIfPresent(String.self, forKey: .custom(name)) ?? option.defaultValue!
                } else {
                    // If decode fails this will trigger an error to the cli "missing argument".
                    value = try container.decode(String.self, forKey: .custom(name))
                }
                parsedAttributes[name] = value
            }
        }
        
        
        self.config = Action.Configuration.init()
        let mirror = Mirror(reflecting: config!)
        for property in mirror.children {
            if let name = property.label?.trimmingCharacters(in: .init(charactersIn: "_")),
               let parsedValue = parsedAttributes[name] {
                (property.value as! ActionParam).wrappedValue = parsedValue
            }
        }
    }

    
}
