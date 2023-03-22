//  Shell+Commands.swift

import Foundation

extension Shell {

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

}
