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
}

struct RemoteConstants {
    static let gitHubProjectURL = URL(string: "https://github.com/InterstellarTools/StellarPrototype")!
    static let gitHubAPIBaseURL = URL(string: "https://api.github.com/repos/tuist/tuist")!
    static let gitHubReleasesList = gitHubAPIBaseURL.appendingPathComponent("releases")
    static let releaseZipFile = "release.zip"

    static func releasesURL(forVersion version: String) -> URL {
        RemoteConstants.gitHubProjectURL.appendingPathComponent("releases/download/\(version)/StellarCLI.zip")
    }
    
}
