//  Editor.swift

import Foundation
import ShellOut

final public class Editor {
    
    public init() {}
    
    public func edit(at location: URL) throws {
        let executorUrl = try URLManager().executorUrl(at: location)
        try shellOut(
            to: "xed",
            arguments: [executorUrl.path],
            outputHandle: .standardOutput,
            errorHandle: .standardError)
    }
}
