//  UninstallService.swift

import Foundation

// MARK: - UninstallServiceProtocol

protocol UninstallServiceProtocol: AnyObject {
    var fileManager: FileManaging { get }
    
    /// Uninstall StellarEnv tool.
    ///
    /// - Parameter version: the version to uninstall.
    func uninstall(version: String) throws
}

public final class UninstallService: UninstallServiceProtocol {
    
    let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func uninstall(version: String) throws {
        let installationURL = URLManager(fileManager: fileManager)
            .homeStellarLocation(subfolder: FileConstants.versionsFolder)
            .appendingPathComponent(version)
        
        guard fileManager.folderExists(at: installationURL) else {
            Logger.error?.write("Stellar version not found at: \(installationURL.path)")
            return
        }
        
        try fileManager.deleteFolder(at: installationURL)
        Logger.info?.write("StellarEnv version \(version) uninstalled")
    }
}
