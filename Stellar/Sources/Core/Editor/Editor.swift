//  Editor.swift

import Foundation
import ShellOut

final public class Editor {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func edit(at location: URL) throws {
        let executorUrl = urlManager.executorUrl(at: location)
        try fileManager.verifyFolderExisting(at: executorUrl)
        
        try shellOut(
            to: "xed",
            arguments: [executorUrl.path],
            outputHandle: .standardOutput,
            errorHandle: .standardError)
    }
}
