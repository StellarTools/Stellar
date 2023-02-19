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
}

struct RemoteConstants {
    // TODO: To replace with stellar urls *InterstellarTools/StellarPrototype.
    static let gitHubProjectURL = URL(string: "https://github.com/tuist/tuist")! //  https://github.com/InterstellarTools/StellarPrototype
    static let gitHubAPIBaseURL = URL(string: "https://api.github.com/repos/tuist/tuist")! // https://api.github.com/repos/InterstellarTools/StellarPrototype
    static let gitHubReleasesList = gitHubAPIBaseURL.appendingPathComponent("releases")
    static let releaseZip = "release.zip"
    
    // TODO: To replace with Stellar* counterparts
    static let stellarPackage = "\(stellarCLI).zip" // "StellarCLI"
    static let stellarCLI = "tuist" // "StellarCLI"

    static let stellarEnvCLI = "tuistenv" // "stellarenv"
    static let stellarEnvPackage = "\(stellarEnvCLI).zip" // "StellarEnv"
    
    static func releasesURL(forVersion version: String, assetsName: String) -> URL {
        RemoteConstants.gitHubProjectURL.appendingPathComponent("releases/download/\(version)/\(assetsName)")
    }
    
}
