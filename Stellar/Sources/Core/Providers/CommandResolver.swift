import Foundation

enum CommandForwarderError: Error {
    case versionNotFound

    var description: String {
        switch self {
        case .versionNotFound:
            return "No valid version has been found locally"
        }
    }
}

public final class CommandResolver {
    
    // MARK: - Public Properties
    
    private var urlManager = URLManager()
    private var versionResolver: VersionResolving
    private var bundleUpdater: BundleUpdater
    
    // MARK: - Private Properties
    
    private let exiter: (Int) -> Void = { exit(Int32($0)) }

    // MARK: - Initialization
    
    public init(releaseProvider: ReleaseProviding = ReleaseProvider(),
                versionResolver: VersionResolving = VersionResolver()) {
        self.bundleUpdater = .init(releaseProvider: releaseProvider)
        self.versionResolver = versionResolver
    }
    
    // MARK: - Public Functions
    
    public func run(args: [String]) throws {
        // We should check to what version of `stellar` in `~/.stellar/Versions` we should
        // forward requested commands.
        let resolvedVersion = try versionResolver.resolveTraversingFromPath(urlManager.currentWorkingDirectory())
        switch resolvedVersion {
        case .bin(let binURL):
            Logger().log("Using stellar bundled at \(binURL.path)")
            try runCommandsUsingBinAtPath(URL(fileURLWithPath: binURL.path), commandArgs: args)
        
        case .versionFile(let fileURL, let pinnedVer):
            Logger().log("Using version \(pinnedVer) defined at \(fileURL.path)")
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

        do {
            try Shell.shared.runAndPrint(args)
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
            Logger().log("\(version) is not a valid version to use")
            exiter(1)
            return
        }
            
        // Check if version is available locally, install if necessary.
        guard let versionURL = try bundleUpdater.update(toVersion: version) else {
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
        
        if let highgestVersion = try bundleUpdater.cliInstaller.latestInstalledVersion() {
            // Get the latest version installed locally.
            targetVersion = highgestVersion.version.description
        } else {
            // Nothing installed, we try to update all.
            _ = try bundleUpdater.update(toVersion: nil)
            guard let highgestVersion = try bundleUpdater.cliInstaller.latestInstalledVersion() else {
                throw CommandForwarderError.versionNotFound
            }
            
            targetVersion = highgestVersion.version.description
        }
        
        guard let targetVersionPath = try bundleUpdater.versionResolver.pathForVersion(targetVersion)?.path else {
            Logger().log("Failed to use version \(targetVersion ?? ""). Aborting the process...")
            exiter(1)
            return
        }
        
        let binURL = URL(fileURLWithPath: targetVersionPath)
        return try runCommandsUsingBinAtPath(binURL, commandArgs: args)
    }
    
}
