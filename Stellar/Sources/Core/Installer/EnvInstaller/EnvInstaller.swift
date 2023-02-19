import Foundation
import ShellOut
import AppKit

protocol EnvInstalling {

    func install(version: String) async throws
    
}


public final class EnvInstaller: EnvInstalling {
    
    private let fileManager: FileManaging

    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func install(version: String) throws {
        do {
            let envRemoteURL = RemoteConstants.releasesURL(forVersion: version, assetsName: RemoteConstants.stellarEnvPackage)
            // TODO: Replace with `stellar`
            let installationPath = try shellOut(to: "which", arguments: ["ruby"]).replacingOccurrences(of: "ruby", with: "tuistenv")
            
            Logger().log("Downloading StellarEnv version \(version)")
        
            try fileManager.withTemporaryDirectory(
                path: nil,
                prefix: "stellarenv_installation",
                autoRemove: false, { temporaryURL in
                    
                    print(ProcessInfo.processInfo.arguments[0])
                    
                    // Download bundle
                    let downloadFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvPackage)
                    try shellOut(to: "/usr/bin/curl", arguments: ["-LSs","--output", downloadFileURL.path, envRemoteURL.absoluteString])
                    NSWorkspace.shared.activateFileViewerSelecting([downloadFileURL])

                    // Unzip
                    Logger().log("Expading the archive…")
                    try shellOut(to: "/usr/bin/unzip",
                                 arguments: ["-q", downloadFileURL.path, RemoteConstants.stellarEnvCLI, "-d", temporaryURL.path])
                 
                    // Remove old version
                    Logger().log("Installing…")
                    let cliToolFileURL = temporaryURL.appendingPathComponent(RemoteConstants.stellarEnvCLI)
                    //try shellOut(to: "sudo", arguments: ["mv", cliToolFileURL.path, installationPath])
                    
                    
                    Logger().log("StellarEnv version \(version) installed")
                }
            )
            

        } catch {
            let e = error as! ShellOutError
            print((error as? ShellOutError)?.errorDescription ?? "")
        }
        
    }
    
    
    
}
