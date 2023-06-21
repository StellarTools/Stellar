//  ActionProtocol.swift

import Foundation

public protocol ActionProtocol {
    associatedtype Configuration: ActionConfigurationProtocol
    
    static var configType: Configuration.Type { get set }
    
    func run(config: Configuration) throws
    
    init()
}

extension ActionProtocol {
    
    public static func actionOptions() -> [ActionParamProtocol] {
        configType.init().options()
    }
}
