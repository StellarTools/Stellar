//  EnvironmentManager.swift

import Foundation

public class EnvironmentManager {
    
    private var storage = [String: String]()
    
    static var shared = EnvironmentManager()
    
    func addVariable(_ envValue: String, for key: String) {
        storage[key] = envValue
    }
    
    func resolve(_ key: String) -> String? {
        storage[key]
    }
    
}
