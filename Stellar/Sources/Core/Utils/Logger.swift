//  Logger.swift

import Foundation

public class Logger {
    
    public func log(_ message: String) {
        print("[\(FolderConstants.stellar)] \(message)")
    }
}
