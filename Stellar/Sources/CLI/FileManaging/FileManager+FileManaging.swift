//  FileManager+FileManaging.swift

import Foundation

extension FileManager: FileManaging {
    
    var currentLocation: URL {
        URL(fileURLWithPath: currentDirectoryPath)
    }
    
    var executableLocation: URL {
        URL(fileURLWithPath: CommandLine.arguments.first!)
            .deletingLastPathComponent()
    }
}
