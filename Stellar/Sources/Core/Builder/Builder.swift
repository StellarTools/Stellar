//  Builder.swift

import Foundation
import ShellOut

final public class Builder {
    
    public init() {}
    
    private let urlManager = URLManager()
    
    public func build(at location: URL) throws {
        let executorUrl = try urlManager.existingExecutorUrl(at: location)
        try shellOut(
            to: "swift",
            arguments: ["build", "-c release"],
            at: executorUrl.path,
            outputHandle: .standardOutput,
            errorHandle: .standardError)
        
        let binaryPath = try shellOut(
            to: "swift",
            arguments: ["build", "-c release", "--show-bin-path"],
            at: executorUrl.path,
            errorHandle: .standardError)
        
        let binaryUrl = URL(fileURLWithPath: binaryPath)
            .appendingPathComponent(Constants.executor, isDirectory: false)
        
        let executablesUrl = try executablesUrl(at: location)
        
        try shellOut(
            to: "mv",
            arguments: ["\(binaryUrl.path)", "\(executablesUrl.path)"],
            at: executorUrl.path,
            outputHandle: .standardOutput,
            errorHandle: .standardError)
    }
    
    private func executablesUrl(at location: URL) throws -> URL {
        do {
            return try urlManager.existingExecutablesUrl(at: location)
        } catch StellarError.missingExecutablesFolder(let url) {
            try Writer().createFolderIfMissing(at: url)
            return try urlManager.existingExecutablesUrl(at: location)
        }
    }
}
