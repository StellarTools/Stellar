import Foundation
import ShellOut

public final class System {
    
    public static var shared = System()
    
    public func which(_ name: String) throws -> String {
        do {
            try shellOut(to: "which", arguments: [name])
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
}
