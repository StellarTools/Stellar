// Transports+Utils.swift

import Foundation

let stdOutSupportColors: Bool = {
    if let cliColorForce = ProcessInfo.processInfo.environment["CLICOLOR_FORCE"],
       ["1", "yes", "true"].contains(cliColorForce) {
        return true
    }
    
    guard isatty(STDOUT_FILENO) == 1 else {
        return false
    }
    
    if let xpcServiceName = ProcessInfo.processInfo.environment["XPC_SERVICE_NAME"],
       xpcServiceName.localizedCaseInsensitiveContains("com.apple.dt.xcode") {
        return false
    }
    
    guard let term = ProcessInfo.processInfo.environment["TERM"],
          !["", "dumb", "cons25", "emacs"].contains(term) else {
        return false
    }
    
    return true
}()
