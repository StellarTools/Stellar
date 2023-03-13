import Foundation

public protocol VersionResolving {
    
    /// Return what version of `stellar` we should use at given path.
    ///
    /// - At the specified path we have a `.stellar-version` file which pins a specific stellar version
    /// - Optionally, we may have a `.stellar-bin` folder with the binary of stellar we should use.
    ///
    /// - Parameter path: path of the project.
    /// - Returns: local release to use.
    func resolveVersionForPath(_ path: URL) throws -> ResolvedVersion

    /// Get a list of the installed versions.
    ///
    /// - Returns: list of `LocalRelease` instances.
    func installedVersions() throws -> [LocalVersion]
    
    /// Get the latest installed version.
    ///
    /// - Returns: the latest installed version, if existing.
    func latestInstalledVersion() throws -> LocalVersion?
    
    /// Return the path to the folder that contains a `stellar` CLI tool for the specified version.
    ///
    /// - Parameter version: version to get.
    /// - Returns: path if installed, `nil` otherwise.
    func pathForVersion(_ version: String) throws -> URL
    
    /// Checks if a version is installed.
    ///
    /// - Parameter version: version to check.
    /// - Returns: `true` if the specified version is available locally.
    func isVersionInstalled(_ version: String) throws -> Bool
    
}

// MARK: - ResolvedVersion

/// Identify what kind of version has been resolved.
public enum ResolvedVersion: Equatable {
    // Binary version contained in `.stellar-bin` folder of the path.
    case bin(LocalVersion)
    // A release pinned using the `.stellar-version` file into the path.
    case versionFile(_ url: URL, _ version: String)
    // Not resolved.
    case undefined
}

// MARK: - VersionResolver

/// Resolve `stellar` cli tool to use for executing requests.
public final class VersionResolver: VersionResolving {
    
    // MARK: - Private Properties
    
    private let fileManager: FileManaging
    private let urlManager = URLManager()
    
    // MARK: - Initialization
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: - Public Functiosn

    public func installedVersions() throws -> [LocalVersion] {
        try urlManager.cliVersionsLocation().glob("*").compactMap {
            LocalVersion(path: $0)
        }.sorted().reversed()
    }
    
    public func latestInstalledVersion() throws -> LocalVersion? {
        try installedVersions().first
    }
    
    public func pathForVersion(_ version: String) throws -> URL {
        try urlManager.cliLocation(for: version)
    }

    public func isVersionInstalled(_ version: String) throws -> Bool {
        let binURL = try pathForVersion(version).appendingPathComponent(FileConstants.binName)
        return fileManager.fileExists(at: binURL)
    }
    
    public func resolveVersionForPath(_ path: URL) throws -> ResolvedVersion {
        let versionFileURL = path.appendingPathComponent(FileConstants.versionsFile)
        let binFolderURL = path.appendingPathComponent(FileConstants.binFolder)
        
        if fileManager.fileExists(at: binFolderURL.appendingPathComponent(FileConstants.binName)) {
            // User specified a `.stellar-bin` with the binary installation of stellar to use. (SHOULD WE INCLUDE IT IN MVP?)
            guard let binRelease = LocalVersion(path: binFolderURL.path) else {
                return .undefined
            }
            return .bin(binRelease)
        } else if fileManager.fileExists(at: versionFileURL) {
            return try resolveVersionFile(url: versionFileURL)
        }
        
        return .undefined
    }
    
    // MARK: - Private Functions
    
    /// The version specified at `stellar-version` file at given path.
    ///
    /// - Parameter path: path of the project.
    /// - Returns: return the pinned version or, if not set, `nil`.
    private func resolveVersionFile(url: URL) throws -> ResolvedVersion {
        var pinnedVer: String!
        do {
            pinnedVer = try String(contentsOf: URL(fileURLWithPath: url.path))
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw Errors.readError(url)
        }
        return ResolvedVersion.versionFile(url, pinnedVer)
    }
    
}

// MARK: - Errors

extension VersionResolver {
    
    enum Errors: FatalError, Equatable {
        case readError(_ versionFileURL: URL)
        
        var description: String {
            switch self {
            case let .readError(versionFileURL):
                return "Cannot read the version file at path \(versionFileURL.path)"
            }
        }
        
        var type: ErrorType {
            .abort
        }
        
    }
    
}
