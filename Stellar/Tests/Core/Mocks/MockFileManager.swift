//  MockFileManager.swift

import Foundation
import StellarCore

class MockFileManager: FileManaging {

    enum MockFileManagerError: Error {
        case missingFile(URL)
        case missingFolder(URL)
    }

    var files = [URL: Data]()
    var folders = [URL]()

    func fileExists(at location: URL) -> Bool {
        files[location] != nil
    }

    func folderExists(at location: URL) -> Bool {
        folders.contains(location)
    }

    func createFile(at location: URL, content data: Data) throws {
        files[location] = data
    }

    func createFolder(at location: URL) throws {
        folders.append(location)
    }

    func deleteFile(at location: URL) throws {
        files[location] = nil
    }

    func deleteFolder(at location: URL) throws {
        folders.removeAll { $0 == location }
    }

    func verifyFileExisting(at location: URL) throws {
        guard fileExists(at: location) else {
            throw MockFileManagerError.missingFile(location)
        }
    }

    func verifyFolderExisting(at location: URL) throws {
        guard folderExists(at: location) else {
            throw MockFileManagerError.missingFolder(location)
        }
    }

    func enumerator(at location: URL) -> FileManager.DirectoryEnumerator? {
        FileManager.default.enumerator(at: location)
    }
}
