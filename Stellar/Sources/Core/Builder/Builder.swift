//  Builder.swift

import Foundation

final public class Builder {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func build(at location: URL) throws {
        let executorLocation = urlManager.executorUrl(at: location)
        try fileManager.verifyFolderExisting(at: executorLocation)

        try Shell.run(["swift", "build", "-c", "release"],
                      workingDirectory: executorLocation.path)

        let binaryPath = try Shell.run(["swift", "build", "-c", "release", "--show-bin-path"],
                                       workingDirectory: executorLocation.path)
        
        let binaryLocation = URL(fileURLWithPath: binaryPath)
            .appendingPathComponent(Constants.executor, isDirectory: false)
        
        let executablesLocation = urlManager.executablesUrl(at: location)
        try? fileManager.createFolder(at: executablesLocation)
        try fileManager.copyFile(at: binaryLocation,
                                 to: executablesLocation.appendingPathComponent(Constants.executor))    }
}
