import Foundation

public final class CommandRunner {
    
    static func arguments() -> [String] {
        Array(ProcessInfo.processInfo.arguments).filter { $0 != "--verbose" }
    }
    
    func run() throws {
        
    }
}
