//  FileManaging.swift

import Foundation

public protocol FileManaging {
    var currentLocation: URL { get }
    var homeDirectoryForCurrentUser: URL { get }
    var temporaryDirectory: URL { get }

    func fileExists(at location: URL) -> Bool
    func folderExists(at location: URL) -> Bool
    func createFile(at location: URL, content data: Data) throws
    func createFolder(at location: URL) throws
    func copyFile(at sourceLocation: URL, to destinationLocation: URL) throws
    func deleteFile(at location: URL) throws
    func deleteFolder(at location: URL) throws
    func verifyFileExisting(at location: URL) throws
    func verifyFolderExisting(at location: URL) throws
    func enumerator(at location: URL) -> FileManager.DirectoryEnumerator?
    func withTemporaryDirectory<Result>(path: String?, prefix: String, autoRemove: Bool, _ closure: (URL) throws -> Result) throws -> Result
    func copyFile(from location: URL, to destination: URL) throws
}
