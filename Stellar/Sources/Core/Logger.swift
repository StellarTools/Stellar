//  Logger.swift

import Foundation

public class Logger {
    
    public static func log(_ message: String) {
        print("[\(Constants.stellar)] \(message)")
    }
}
