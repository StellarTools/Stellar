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

public final class CommandForwarder {
    
    // MARK: - Public Properties
    
    private var urlManager = URLManager()
    public var versionResolver = VersionResolver()
    public var installer = CLIInstaller()
    public var updater = BundleUpdater()
    
    // MARK: - Private Properties
    
    private let exiter: (Int) -> Void = { exit(Int32($0)) }

    // MARK: - Initialization
    
    public init() { }
    
    // MARK: - Public Functions
    
    public func run(args: [String]) throws {
        // We should check to what version of `stellar` in `~/.stellar/Versions` we should
        // forward requested commands.
        let resolvedVersion = try versionResolver.resolveTraversingFromPath(urlManager.currentLocation())
        switch resolvedVersion {
        case .bin(let binURL):
            Logger().log("Using stellar bundled at \(binURL.path)")
            try runCommandsUsingBinAtPath(URL(fileURLWithPath: binURL.path), args: args)
        
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
    private func runCommandsUsingBinAtPath(_ path: URL, args: [String]) throws {
        var args: [String] = [
            path.appendingPathComponent(FileConstants.binName).path // path of the cli tool to call
        ]
        args.append(contentsOf: Array(args.dropFirst())) // forward all params to the tool

        do {
            try System.shared.runAndPrint(args)
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
            
        // Version is not available locally, we would to retrive it remotely.
        if try installer.isVersionInstalled(version) == false {
            Logger().log("Version \(version) not found locally. Installing...")
            try installer.install(version: version)
        }
        
        // Attempt to get the path of the release.
        guard let versionPath = try installer.pathForVersion(version)?.path else {
            Logger().log("Failed to use version \(version). Aborting the process...")
            exiter(1)
            return
        }
        
        try runCommandsUsingBinAtPath(URL(fileURLWithPath: versionPath), args: args)
    }
    
    /// Run with highest installed version. If no versions are installed the latest will
    /// be downloaded and executed.
    ///
    /// - Parameter args: arguments to pass.
    private func runCommandsUsingLatestInstalledVersion(args: [String]) throws {
        var targetVersion: String!
        
        if let highgestVersion = try installer.latestInstalledVersion() {
            // Get the latest version installed locally.
            targetVersion = highgestVersion.version.description
        } else {
            // Nothing installed, we try to update all.
            try updater.update()
            guard let highgestVersion = try installer.latestInstalledVersion() else {
                throw CommandForwarderError.versionNotFound
            }
            
            targetVersion = highgestVersion.version.description
        }
        
        guard let targetVersionPath = try installer.pathForVersion(targetVersion)?.path else {
            Logger().log("Failed to use version \(targetVersion ?? ""). Aborting the process...")
            exiter(1)
            return
        }
        
        let binURL = URL(fileURLWithPath: targetVersionPath).appendingPathComponent(FileConstants.binName)
        return try runCommandsUsingBinAtPath(binURL, args: args)
    }
    
}
