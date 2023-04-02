//  Builder.swift

import Foundation

final public class Builder {
    
    private let urlManager = URLManager()
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func build(at location: URL) throws {
        let executorPackageLocation = urlManager.executorPackageUrl(at: location)
        try fileManager.verifyFolderExisting(at: executorPackageLocation)

        try Shell.run(
            ["swift", "build", "-c", "release"],
            workingDirectory: executorPackageLocation.path
        )

        let binaryPath = try Shell.runAndCollect(
            ["swift", "build", "-c", "release", "--show-bin-path"],
            workingDirectory: executorPackageLocation.path
        )
        
        let binaryLocation = URL(fileURLWithPath: binaryPath)
            .appendingPathComponent(Constants.executor, isDirectory: false)
        
        let executablesLocation = urlManager.executablesUrl(at: location)
        try? fileManager.createFolder(at: executablesLocation)
        try fileManager.copyFile(at: binaryLocation,
                                 to: executablesLocation.appendingPathComponent(Constants.executor))
    }
    
}
