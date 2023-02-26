import Foundation

public protocol VersionResolving {
    
    /// Return what version of `stellar` we should use to handle the project
    /// at given path.
    ///
    /// - At the specified path we have a `.stellar-version` file which pin a specific stellar version
    /// - Optionally we may have a `.stellar-bin` folder with the binary of tuist we should use.
    ///
    /// If version is not currently available we would to download it remotely before going forward.
    ///
    /// - Parameter path: path of the project.
    /// - Returns: local release to use.
    func resolveTraversingFromPath(_ path: URL) throws -> ResolvedVersion

}

// MARK: - ResolvedVersion

/// Identify what kind of version has been resolved.
public enum ResolvedVersion: Equatable {
    // Binary version contained in `.stellar-bin` folder of the path.
    case bin(LocalRelease)
    // A release pinned using the `.stellar-version` file into the path.
    case versionFile(_ url: URL, _ version: String)
    // Not resolved.
    case undefined
}

enum VersionResolverError: Error, Equatable {
    case readError(_ versionFileURL: URL)

    var description: String {
        switch self {
        case let .readError(versionFileURL):
            return "Cannot read the version file at path \(versionFileURL.path)"
        }
    }
}

// MARK: - VersionResolver

/// Resolve `stellar` cli tool to use for executing requests.
public final class VersionResolver: VersionResolving {
    
    // MARK: - Private Properties
    
    private let fileManager: FileManaging
    
    // MARK: - Initialization
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: - Public Functiosn
    
    public func resolveTraversingFromPath(_ path: URL) throws -> ResolvedVersion {
        let versionFileURL = path.appendingPathComponent(FileConstants.versionsFile)
        let binFolderURL = path.appendingPathComponent(FileConstants.binFolder)
        
        if fileManager.fileExists(at: binFolderURL.appendingPathComponent(FileConstants.binName)) {
            // User specified a `.stellar-bin` with the binary installation of stellar to use. (SHOULD WE INCLUDE IT IN MVP?)
            guard let binRelease = LocalRelease(path: binFolderURL.path) else {
                return .undefined
            }
            return .bin(binRelease)
        } else if fileManager.fileExists(at: versionFileURL) {
            return try resolveVersionFile(url: versionFileURL)
        }
        
        return .undefined
    }
    
    // MARK: - Private Functions
    
    /// Return the version specified at `stellar-version` file at given path.
    ///
    /// - Parameter path: path of the project.
    /// - Returns: return the pinned version or, if not set, `nil`.
    private func resolveVersionFile(url: URL) throws -> ResolvedVersion {
        var pinnedVer: String!
        do {
            pinnedVer = try String(contentsOf: URL(fileURLWithPath: url.path))
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw VersionResolverError.readError(url)
        }
        return ResolvedVersion.versionFile(url, pinnedVer)
    }
    
}
