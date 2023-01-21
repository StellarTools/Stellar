//  Logger.swift

import Foundation

public class Logger {
    
    public func log(_ message: String) {
        print("[\(Constants.stellar)] \(message)")
    }
    
    public func hint(_ message: String) {
        print("[\(Constants.stellarHint)] \(message)")
    }
    
}
