//  Command.swift

import ArgumentParser
import Foundation
import ScanAction

public class ScanActionCLI: ParsableCommand, CustomReflectable  {
    public typealias Action = ScanAction
    
    // MARK: - Private Properties
    
    // private static var availableOptions = [ActionOptionProtocol]()
    
    // This configuration contains all configuration parameters of the action
    // read directly from the command line interface.
    private var config: Action.Configuration!
    
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
    
    // MARK: - Private Methods
    
    // PART 1:
    // We want to mock the  ArgumentParser  so that it will believe
    // that it contains properties declared in the `Action.Configuration`.
    
    /*
     // This should be not necessary.
     static func preprocess(_ arguments: [String]) throws {
         Self.availableOptions = Action.actionOptions()
    }
     */
    
    public var customMirror: Mirror {
        // By implementing a custom Mirror, we can mock the  ArgumentParser  which uses Mirror to read the
        // variables declared in the class, such as  @Flag ,  @Option , and so on.
        // At the end of this function, we have created a list of our variables
        // that were directly read from the action configuration.
        var list = [Mirror.Child]()
        for property in Action.actionOptions() { // Self.availableOptions {
            let child: Mirror.Child
            // We can make something better here, it's just to test how it works with optional parasmeters.
            if property.isRequired {
                child = Mirror.Child(label: property.name!, value: Option<String>(name: .shortAndLong))
            } else {
                child = Mirror.Child(label: property.name!, value: Option<Optional<String>>(name: .shortAndLong))
            }
            list.append(child)
        }
        return Mirror(Self(), children: list)
    }
    
    // PART 2:
    // Since Argument Parser read values of the command line directly from Codable interface
    // we'll parse these values and assign via Mirror to our `config`'s `wrappedValue`.
    // Et voilà!
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var parsedAttributes = [String: String]()
        try Action.actionOptions().forEach { option in
        // try Self.availableOptions.forEach { option in
            if let name = option.name {
                parsedAttributes[name] = try container.decodeIfPresent(String.self, forKey: .custom(name))
            }
        }
        
        
        self.config = .init()
        let mirror = Mirror(reflecting: config!)
        for property in mirror.children {
            if let name = property.label?.trimmingCharacters(in: .init(charactersIn: "_")),
               let parsedValue = parsedAttributes[name] {
                (property.value as! ActionParam).wrappedValue = parsedValue
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case custom(String)
     
        init?(stringValue: String) {
            self = .custom(stringValue)
        }
        
        var stringValue: String {
            switch self {
            case let .custom(name): return name
            }
        }
        
        // Just to silence the compiler, never used.
        var intValue: Int? { nil }
        init?(intValue _: Int) { nil }
    }
    
}
