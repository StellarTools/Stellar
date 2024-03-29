//  Constants.swift

import Foundation

struct Constants {
    static let stellar = "Stellar"
    static let stellarHint = "Stellar Hint ⭐️"
    static let executor = "Executor"
}

struct FileConstants {
    static let versionsFile = ".stellar-version"
    static let binFolder = ".stellar-bin"
    static let binName = "stellarCLI"
    static let toolFolder = ".stellar"
    static let envInstallDirectory = "/usr/local/bin"
    static let envBinName = "stellar"
}

struct GitHubAPI {
    static let projectURL = URL(string: "https://github.com/StellarTools/Stellar")!
    static let apiBaseURL = URL(string: "https://api.github.com/repos/StellarTools/Stellar")!
    static let apiReleases = apiBaseURL.appendingPathComponent("releases")
    static let apiReleaseTag = apiReleases.appendingPathComponent("tags")
    static let apiLatestRelease = apiReleases.appendingPathComponent("latest")
    
    static let tokenFile = ".GITHUB-TOKEN"
    
    static var gitHubToken: String = {
        let tokenFileURL = URLManager().homeStellarLocation()
            .appendingPathComponent(GitHubAPI.tokenFile)
        
        guard FileManager.default.fileExists(at: tokenFileURL) else {
            fatalError("Missing \(GitHubAPI.tokenFile) in ~/\(FileConstants.toolFolder) directory.")
        }
        
        let token = try? String(contentsOf: tokenFileURL)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return token ?? ""
    }()
    
}

struct RemoteConstants {
    static let releaseZip = "release.zip"
    static let stellarCLI = "StellarCLI"
    static let stellarCLIZipAsset = "\(stellarCLI).zip"
    static let stellarEnv = "StellarEnv"
    static let stellarEnvZipAsset = "\(stellarEnv).zip"
}
