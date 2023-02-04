//  FileManaging.swift

import Foundation

public protocol FileManaging {
    var currentLocation: URL { get }
    func fileExists(at location: URL) -> Bool
    func folderExists(at location: URL) -> Bool
    func createFolder(at location: URL) throws
    func deleteFolder(at location: URL) throws
    func verifyFileExisting(at location: URL) throws
    func verifyFolderExisting(at location: URL) throws
    func enumerator(at location: URL) -> FileManager.DirectoryEnumerator?
}
