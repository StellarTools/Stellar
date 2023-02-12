import Foundation
import AppKit
import ShellOut

public protocol InstallManaging {
    
    func installedVersions() throws -> [LocalRelease]
    func install(version: String) async throws
    func pin(url: URL?, toVersion version: String) throws
    
}

public final class InstallerManager: InstallManaging {
    
    private var urlManager = URLManager()
    private let fileManager: FileManaging
    private let networkManager = NetworkManager()
    private let versionProvider = VersionProvider()
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func installedVersions() throws -> [LocalRelease] {
        try urlManager.systemVersionsLocation().glob("*").compactMap {
            LocalRelease(path: $0)
        }.sorted()
    }
    
    public func pin(url: URL?, toVersion version: String) throws {
        let destinationURL = url ?? urlManager.currentLocation()
        
        Logger().log("Generating \(FileConstants.versionsFile) file with version \(version)")
        let fileURL = destinationURL.appendingPathComponent(FileConstants.versionsFile)
        try "\(version)".write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )
        Logger().log("File generated at path \(fileURL.path)")
    }
    
    public func install(version: String) async throws {
        // let releasesURL = URL(string:"https://github.com/tuist/tuist/releases/download/3.15.0/tuistenv.zip")!
        let releasesURL = RemoteConstants.releasesURL(forVersion: version)
        let installURL = try urlManager.systemVersionsLocation(version)
        
        try await fileManager.withTemporaryDirectory(
            path: nil,
            prefix: "installation",
            autoRemove: true, { temporaryURL in
            
                // Download the release zip file
                Logger().log("Downloading stellar v.\(version)...")
                let remoteFileURL = temporaryURL.appendingPathComponent(RemoteConstants.releaseZipFile)
                try await networkManager.downloadFile(atURL: releasesURL, saveAtURL: remoteFileURL)
                
                // Unzip the file
                try fileManager.deleteFolder(at: installURL) // replace if exists
                try shellOut(to: "unzip", arguments: ["-q", remoteFileURL.path, "-d", installURL.path])
                // NSWorkspace.shared.activateFileViewerSelecting([installURL])
                
                Logger().log("Stellar version \(version) installed")
        })
    }
    
}
