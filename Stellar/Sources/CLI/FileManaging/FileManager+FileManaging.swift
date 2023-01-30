//  FileManager+FileManaging.swift

import Foundation

extension FileManager: FileManaging {
    
    var currentLocation: URL {
        URL(fileURLWithPath: currentDirectoryPath)
    }
}
