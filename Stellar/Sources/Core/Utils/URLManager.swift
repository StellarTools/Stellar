//  URLManager.swift

import Foundation

final class URLManager {
    
    var environmentURL: URL {
        FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent(".tuist")//FolderConstants.stellarFolder)
            .appendingPathComponent(FolderConstants.Installation.versions)
    }
    
    func stellarUrl(at location: URL) -> URL {
        location
            .appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
    }
    
    func existingStellarUrl(at location: URL) throws -> URL {
        let stellarUrl = location
            .appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
        guard folderExists(at: stellarUrl) else {
            throw StellarError.missingStellarFolder(stellarUrl)
        }
        return stellarUrl
    }
    
    func packagesUrl(at location: URL) -> URL {
        stellarUrl(at: location)
            .appendingPathComponent(FolderConstants.packagesFolder, isDirectory: true)
    }
    
    func existingPackagesUrl(at location: URL) throws -> URL {
        let packagesUrl = try existingStellarUrl(at: location)
            .appendingPathComponent(FolderConstants.packagesFolder, isDirectory: true)
        guard folderExists(at: packagesUrl) else {
            throw StellarError.missingPackagesFolder(packagesUrl)
        }
        return packagesUrl
    }
    
    func executorUrl(at location: URL) -> URL {
        packagesUrl(at: location)
            .appendingPathComponent(FolderConstants.executorFolder, isDirectory: true)
    }
    
    func existingExecutorUrl(at location: URL) throws -> URL {
        let executorUrl = try existingPackagesUrl(at: location)
            .appendingPathComponent(FolderConstants.executorFolder, isDirectory: true)
        guard folderExists(at: executorUrl) else {
            throw StellarError.missingExecutorFolder(executorUrl)
        }
        return executorUrl
    }
    
    func executorSourcesUrl(at location: URL) -> URL {
        executorUrl(at: location)
            .appendingPathComponent(FolderConstants.sourcesFolder, isDirectory: true)
    }
    
    func existingExecutorSourcesUrl(at location: URL) throws -> URL {
        let executorSourcesUrl = try existingExecutorUrl(at: location)
            .appendingPathComponent(FolderConstants.sourcesFolder, isDirectory: true)
        guard folderExists(at: executorSourcesUrl) else {
            throw StellarError.missingExecutorSourcesFolder(executorSourcesUrl)
        }
        return executorSourcesUrl
    }
    
    func executorPackageUrl(at location: URL) -> URL {
        executorUrl(at: location)
            .appendingPathComponent(FileConstants.packageDotSwift, isDirectory: false)
    }
    
    func existingExecutorPackageUrl(at location: URL) throws -> URL {
        let executorPackageUrl = try existingExecutorUrl(at: location)
            .appendingPathComponent(FileConstants.packageDotSwift, isDirectory: false)
        guard fileExists(at: executorPackageUrl) else {
            throw StellarError.missingExecutorPackage(executorPackageUrl)
        }
        return executorPackageUrl
    }
    
    func executablesUrl(at location: URL) -> URL {
        stellarUrl(at: location)
            .appendingPathComponent(FolderConstants.executablesFolder, isDirectory: true)
    }
    
    func existingExecutablesUrl(at location: URL) throws -> URL {
        let executablesUrl = try existingStellarUrl(at: location)
            .appendingPathComponent(FolderConstants.executablesFolder, isDirectory: true)
        guard folderExists(at: executablesUrl) else {
            throw StellarError.missingExecutablesFolder(executablesUrl)
        }
        return executablesUrl
    }
    
    // MARK: - Private
    
    func folderExists(at location: URL) -> Bool {
        var objcTrue: ObjCBool = true
        return FileManager.default.fileExists(atPath: location.path, isDirectory: &objcTrue)
    }
    
    func fileExists(at location: URL) -> Bool {
        var objcTrue: ObjCBool = false
        return FileManager.default.fileExists(atPath: location.path, isDirectory: &objcTrue)
    }
}
