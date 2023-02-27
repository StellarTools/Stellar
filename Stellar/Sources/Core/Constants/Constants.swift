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
    static let envBinName = "stellarenv"
}

struct GitHubAPI {
    static let projectURL = URL(string: "https://github.com/StellarTools/Stellar")!
    static let apiBaseURL = URL(string: "https://api.github.com/repos/StellarTools/Stellar")!
    static let apiReleases = apiBaseURL.appendingPathComponent("releases")
    static let apiReleaseTag = apiReleases.appendingPathComponent("tags")
    static let apiLatestRelease = apiReleases.appendingPathComponent("latest")
}

struct RemoteConstants {
    static let releaseZip = "release.zip"
    static let stellarPackage = "\(stellarCLI).zip"
    static let stellarCLI = "StellarCLI"

    static let stellarEnvCLI = "StellarEnv"
    static let stellarEnvPackage = "\(stellarEnvCLI).zip"
}
