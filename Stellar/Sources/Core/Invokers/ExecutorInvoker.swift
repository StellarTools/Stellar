//  ExecutorInvoker.swift

import Foundation

public final class ExecutorInvoker {

    // MARK: - Public Properties

    private let urlManager = URLManager()
    private let projectUrl: URL

    // MARK: - Initializer

    public init(projectUrl: URL) {
        self.projectUrl = projectUrl
    }

    // MARK: - Private Properties
    
    private let exiter: (Int) -> Void = { exit(Int32($0)) }
    
    // MARK: - Public Functions
    
    public func run(args: [String]) throws {
        let executorBinaryUrl = URLManager().executorBinaryUrl(at: projectUrl)
        try runCommand(binaryUrl: executorBinaryUrl, commandArgs: args)
    }
    
    // MARK: - Private Functions

    private func runCommand(binaryUrl: URL, commandArgs: [String]) throws {
        var args: [String] = [
            binaryUrl.path
        ]
        args.append(contentsOf: commandArgs)

        do {
            try Shell.run(args)
        } catch {
            exiter(1)
        }
    }
    
}
