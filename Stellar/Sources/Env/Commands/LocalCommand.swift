import ArgumentParser
import Foundation
import StellarCore

/// `LocalCommand` is used to query for installed versions or pin a project to a specific stellar version.
struct LocalCommand: ParsableCommand {
    
    static let configuration = CommandConfiguration(
        commandName: "local",
        abstract: """
            Creates a .stellar-version file to pin the stellar version that
            should be used in the current directory.
            If the version is not specified, it prints the local versions.
        """
    )
    
    // MARK: - Options

    @Option(help: "The version that you would like to pin your current directory to")
    var version: String?
    
    @Option(help: "Directory path used when pin version. If not specified the current working directory.")
    var path: String?
    
    // MARK: - Public Functions
    
    func run() throws {
        if let version {
            try pin(path: path, toVersion: version)
        } else {
            try enumerateInstalledVersions()
        }
    }
    
    // MARK: - Private Functions
    
    /// Pin project at `path` to a specified version of stellar.
    ///
    /// - Parameters:
    ///   - path: path of the project.
    ///   - version: version to pin.
    private func pin(path: String?, toVersion version: String) throws {
        let urlPath = (path != nil ? URL(fileURLWithPath: path!) : nil)
        try CLIInstaller().pin(url: urlPath, toVersion: version)
    }
    
    /// Enumerate the list of the installed versions of stellar.
    private func enumerateInstalledVersions() throws {
        let versions = try CLIInstaller().installedVersions()
        guard !versions.isEmpty else {
            Logger().log("No versions of stellar are installed yet")
            return
        }
        
        Logger().log("Installed versions are:")
        let output = versions.reversed().map { "- \($0)" }.joined(separator: "\n")
        Logger().log("\n\(output)")
    }
    
}
