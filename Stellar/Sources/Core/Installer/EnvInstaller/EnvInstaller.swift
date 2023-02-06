import Foundation
import ShellOut

protocol EnvInstalling {

    func install(version: String) async throws
    
}


public final class EnvInstaller: EnvInstalling {
    
    public init() {
        
    }
    
    public func install(version: String) async throws {

        let binaryPath = try shellOut(to: "which", arguments: ["tuist"])
        
        print(binaryPath)
    }
    
}
