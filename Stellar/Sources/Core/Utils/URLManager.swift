//  URLManager.swift

import Foundation

final class URLManager {
    
    func stellarUrl(at location: URL) throws -> URL {
        let stellarUrl = location
            .appendingPathComponent(Constants.stellarFolder, isDirectory: true)
        guard folderExists(at: stellarUrl) else {
            throw StellarError.missingStellarFolder(stellarUrl)
        }
        return stellarUrl
    }
    
    func executorUrl(at location: URL) throws -> URL {
        let executorUrl = try stellarUrl(at: location)
            .appendingPathComponent(Constants.executorFolder, isDirectory: true)
        guard folderExists(at: executorUrl) else {
            throw StellarError.missingExecutorFolder(executorUrl)
        }
        return executorUrl
    }
    
    func executorPackageUrl(at location: URL) throws -> URL {
        let executorPackageUrl = try executorUrl(at: location)
            .appendingPathComponent(Constants.packageDotSwift, isDirectory: false)
        guard fileExists(at: executorPackageUrl) else {
            throw StellarError.missingExecutorPackage(executorPackageUrl)
        }
        return executorPackageUrl
    }
    
    func executablesUrl(at location: URL) throws -> URL {
        let executablesUrl = try stellarUrl(at: location)
            .appendingPathComponent(Constants.executablesFolder, isDirectory: true)
        guard folderExists(at: executablesUrl) else {
            throw StellarError.missingExecutablesFolder(executablesUrl)
        }
        return executablesUrl
    }
    
    // MARK: - Private
    
    private func folderExists(at location: URL) -> Bool {
        var objcTrue: ObjCBool = true
        return FileManager.default.fileExists(atPath: location.path, isDirectory: &objcTrue)
    }
    
    private func fileExists(at location: URL) -> Bool {
        var objcTrue: ObjCBool = false
        return FileManager.default.fileExists(atPath: location.path, isDirectory: &objcTrue)
    }
}
