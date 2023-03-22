//  CommonCommands.swift

import Foundation

struct CommonCommands {

    /// Download the resource at a given url.
    ///
    /// - Parameters:
    ///   - url: url of resource to download.
    ///   - destinationUrl: destination for saving the file to.
    static func downloadResource(url: URL, at destinationUrl: URL) throws {
        let arguments = [
            "/usr/bin/curl",
            "-LSs",
            "--output",
            destinationUrl.path,
            url.absoluteString
        ]
        try Shell.run(arguments)
    }

    /// Unzip a file at a given local URL.
    ///
    /// - Parameters:
    ///   - fileURL: local URL of the zip file.
    ///   - name: name of file/folder(s).
    ///   - destinationURL: destination location.
    static func unzip(fileURL: URL, name: String? = nil, destinationURL: URL) throws {
        let arguments = [
            "/usr/bin/unzip",
            "-q",
            fileURL.path,
            name,
            "-d",
            destinationURL.path
        ].compactMap({ $0 })
        try Shell.run(arguments)
    }

    /// Copy and replace a file at given location.
    ///
    /// - Parameters:
    ///   - sourceURL: source file.
    ///   - destination: destination location.
    static func copyAndReplace(source: URL, destination: String) throws {
        try Shell.run(["rm", "-f", destination])
        try Shell.run(["mv", source.path, destination])
    }

    /// Execute which with given target name.
    ///
    /// - Parameter name: name of the CLI tool to found.
    /// - Returns: path, if found.
    static func which(_ name: String) throws -> String {
        let arguments = [
            "/usr/bin/env",
            "which",
            name
        ]
        return try Shell.run(arguments).cleanShellOutput()
    }

}
