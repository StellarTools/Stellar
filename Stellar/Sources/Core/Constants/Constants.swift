//  Constants.swift
import Foundation

struct Constants {
    static let stellar = "Stellar"
    static let stellarHint = "Stellar Hint ⭐️"
    static let executor = "Executor"
}

struct HintTemplateNames {
    static let actionCreatedOnDefaultPath = "ActionCreatedOnDefaultPath.stencil"
}

struct FileConstants {
    static let versionsFile = ".stellar-version"
    static let binFolder = ".stellar-bin"
    static let binName = ".stellar"
    static let envInstallDirectory = "/usr/local/bin"
}

struct RemoteConstants {
    // TODO: To replace with stellar urls *InterstellarTools/StellarPrototype.
    static let gitHubProjectURL = URL(string: "https://github.com/InterstellarTools/StellarPrototype")!
    static let gitHubAPIBaseURL = URL(string: "https://api.github.com/repos/InterstellarTools/StellarPrototype")!
    static let gitHubReleasesList = gitHubAPIBaseURL.appendingPathComponent("releases")
    static let releaseZip = "release.zip"
    
    // TODO: To replace with Stellar* counterparts
    static let stellarPackage = "\(stellarCLI).zip"
    static let stellarCLI = "StellarCLI"

    static let stellarEnvCLI = "StellarEnv"
    static let stellarEnvPackage = "\(stellarEnvCLI).zip"
    
    static func releasesURL(forVersion version: String, assetsName: String) -> URL {
        RemoteConstants.gitHubProjectURL.appendingPathComponent("releases/download/\(version)/\(assetsName)")
    }
    
}
