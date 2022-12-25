//  URLManager.swift

import Foundation

final class URLManager {
    
    func stellarUrl(at location: URL) throws -> URL {
        let stellarUrl = location
            .appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
        guard folderExists(at: stellarUrl) else {
            throw StellarError.missingStellarFolder(stellarUrl)
        }
        return stellarUrl
    }
    
    func executorUrl(at location: URL) throws -> URL {
        let executorUrl = try stellarUrl(at: location)
            .appendingPathComponent(FolderConstants.executorFolder, isDirectory: true)
        guard folderExists(at: executorUrl) else {
            throw StellarError.missingExecutorFolder(executorUrl)
        }
        return executorUrl
    }
    
    func executorSourcesUrl(at location: URL) throws -> URL {
        let executorSourcesUrl = try executorUrl(at: location)
            .appendingPathComponent(FolderConstants.sourcesFolder, isDirectory: true)
        guard folderExists(at: executorSourcesUrl) else {
            throw StellarError.missingExecutorSourcesFolder(executorSourcesUrl)
        }
        return executorSourcesUrl
    }
    
    func executorPackageUrl(at location: URL) throws -> URL {
        let executorPackageUrl = try executorUrl(at: location)
            .appendingPathComponent(FolderConstants.packageDotSwift, isDirectory: false)
        guard fileExists(at: executorPackageUrl) else {
            throw StellarError.missingExecutorPackage(executorPackageUrl)
        }
        return executorPackageUrl
    }
    
    func executablesUrl(at location: URL) throws -> URL {
        let executablesUrl = try stellarUrl(at: location)
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
