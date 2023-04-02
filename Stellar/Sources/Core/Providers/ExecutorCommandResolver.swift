//  ExecutorCommandResolver.swift

import Foundation

public final class ExecutorCommandResolver {

    // MARK: - Public Properties
    
    private let urlManager = URLManager()

    // MARK: - Private Properties
    
    private let exiter: (Int) -> Void = { exit(Int32($0)) }

    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Public Functions
    
    public func run(projectUrl: URL, args: [String]) throws {
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
