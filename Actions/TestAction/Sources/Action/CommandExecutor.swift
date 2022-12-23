//  CommandExecutor.swift

import Foundation
import ShellOut

public typealias Argument = String
public typealias Location = String

public struct CommandExecutor {
    
    @discardableResult
    static public func executeXcodebuild(command: String, arguments: [Argument], at location: Location?) throws -> String {
        let commandArguments = ([command] + arguments).joined(separator: " ")
        let executionPath = location ?? "./"
        print("⌨️ Executing:")
        print("command: '\(Constants.xcodebuild) \(commandArguments)'")
        print("at: '\(executionPath)'")
        
        print("🤖 Command output:")
        return try shellOut(to: Constants.xcodebuild,
                            arguments: [command] + arguments,
                            at: executionPath,
                            outputHandle: .standardOutput,
                            errorHandle: .standardError)
    }
}
