import Foundation

public final class LocalService {
    
    // MARK: - Properties
    
    private let manager: VersionsManager
    
    // MARK: - Initialization
    
    public init(_ manager: VersionsManager = .init()) {
        self.manager = manager
    }
    
    // MARK: - Public Functions
    
    public func run(version: String?, path: String?) throws {
        if let version {
            try createVersionFile(version: version, path: path)
        } else {
            try printLocalVersions()
        }
    }
    
    // MARK: - Private Functions
    
    /// Print the local installed versions.
    private func printLocalVersions() throws {
        let versions = manager.versions()
        guard !versions.isEmpty else {
            Logger().log("No versions of stellar are installed yet")
            return
        }
        
        Logger().log("The following versions are available in the local environment:")
        let output = versions.reversed().map { "- \($0)" }.joined(separator: "\n")
        Logger().log("\n\(output)")
    }
    
    /// Create `.stellar-version` file to pin the version used of stellaer inside
    /// passed directory. If not specified the current working directory is used instead.
    ///
    /// - Parameters:
    ///   - version: version to pin.
    ///   - path: path of the working directory.
    private func createVersionFile(version: String, path: String?) throws {
        let currentURL = URL(fileURLWithPath: path ?? FileManager.default.currentDirectoryPath)
        
        Logger().log("Generating \(FileConstants.versionFileName) file with version \(version)")
        let fileURL = currentURL.appendingPathComponent(FileConstants.versionFileName)
        try "\(version)".write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )
        Logger().log("File generated at path \(fileURL.path)")
    }
    
    
}
