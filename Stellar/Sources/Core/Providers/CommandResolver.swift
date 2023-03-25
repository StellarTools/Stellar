//  CommandResolver.swift

import Foundation

public final class CommandResolver {

    // MARK: - Public Properties
    
    private let urlManager = URLManager()
    private let versionResolver: VersionResolving
    private let updateService: UpdateService
        
    // MARK: - Private Properties
    
    private let exiter: (Int) -> Void = { exit(Int32($0)) }

    // MARK: - Initialization
    
    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.updateService = .init(releaseProvider: releaseProvider)
        self.versionResolver = versionResolver
    }
    
    // MARK: - Public Functions
    
    public func run(args: [String]) throws {
        // We should check to what version of `stellar` in `~/.stellar/Versions` we should
        // forward requested commands.
        let resolvedVersion = try versionResolver.resolveVersionForPath(urlManager.currentWorkingDirectory())
        switch resolvedVersion {
        case .bin(let binURL):
            Logger.debug?.write("Using stellar bundled at \(binURL.path)")
            try runCommandsUsingBinAtPath(URL(fileURLWithPath: binURL.path), commandArgs: args)
        
        case .versionFile(let fileURL, let pinnedVer):
            Logger.debug?.write("Using version \(pinnedVer) defined at \(fileURL.path)")
            try runCommandsUsingVersion(pinnedVer, args: args)
        
        default:
            try runCommandsUsingLatestInstalledVersion(args: args)
            
        }
    }
    
    // MARK: - Private Functions
    
    /// Forward commands to the `stellar` bin specified at path.
    ///
    /// - Parameters:
    ///   - path: path of the CLI tool to call.
    ///   - args: arguments to pass.
    private func runCommandsUsingBinAtPath(_ path: URL, commandArgs: [String]) throws {
        var args: [String] = [
            path.appendingPathComponent(FileConstants.binName).path // path of the cli tool to call
        ]
        args.append(contentsOf: commandArgs) // forward all params to the tool

        Logger.debug?.write("Commands will be resolved by stellarCLI v\(path.lastPathComponent)")
        
        do {
            try Shell.run(args)
        } catch {
            exiter(1)
        }
    }
    
    /// Forward commands to the specified version of `stellar`.
    ///
    /// - Parameters:
    ///   - version: version to forward at.
    ///   - args: arguments to pass.
    private func runCommandsUsingVersion(_ version: String, args: [String]) throws {
        // Validate the format of the version
        guard SemVer(version) != nil else {
            Logger.info?.write("\(version) is not a valid version to use")
            exiter(1)
            return
        }
            
        // Check if version is available locally, install if necessary.
        guard let versionURL = try updateService.update(to: version) else {
            exiter(1)
            return
        }
        
        try runCommandsUsingBinAtPath(versionURL, commandArgs: args)
    }
    
    /// Run with highest installed version. If no versions are installed the latest will
    /// be downloaded and executed.
    ///
    /// - Parameter args: arguments to pass.
    private func runCommandsUsingLatestInstalledVersion(args: [String]) throws {
        var targetVersion: String!
        
        if let highgestVersion = try updateService.cliService.latestInstalledVersion() {
            // Get the latest version installed locally.
            targetVersion = highgestVersion.version.description
        } else {
            // Nothing installed, we try to update all.
            _ = try updateService.update()
            guard let highgestVersion = try updateService.cliService.latestInstalledVersion() else {
                throw Errors.versionNotFound
            }
            
            targetVersion = highgestVersion.version.description
        }
        
        let targetVersionPath = try updateService.versionResolver.pathForVersion(targetVersion).path
        let binURL = URL(fileURLWithPath: targetVersionPath)
        return try runCommandsUsingBinAtPath(binURL, commandArgs: args)
    }
    
}

// MARK: - Errors

extension CommandResolver {
    
    enum Errors: FatalError {
        case versionNotFound
        
        var type: ErrorType {
            .abort
        }

        var description: String {
            switch self {
            case .versionNotFound:
                return "No valid version has been found locally"
            }
        }
    }
    
}
