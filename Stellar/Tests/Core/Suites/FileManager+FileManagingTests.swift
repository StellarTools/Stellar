//  FileManager+FileManagingTests.swift

import XCTest
@testable import StellarCore

final class FileManager_FileManagingTests: XCTestCase {

    private let fileManager = FileManager.default

    func test_fileExists_true() throws {
        let url = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
        XCTAssertTrue(fileManager.fileExists(at: url))
    }

    func test_fileExists_false() throws {
        let url = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
            .deletingPathExtension()
            .appendingPathExtension("notExisting")
        XCTAssertFalse(fileManager.fileExists(at: url))
    }

    func test_folderExists_true() throws {
        let url = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
            .deletingLastPathComponent()
        XCTAssertTrue(fileManager.folderExists(at: url))
    }

    func test_folderExists_false() throws {
        let url = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
            .deletingLastPathComponent()
            .appendingPathComponent("notExisting")
        XCTAssertFalse(fileManager.folderExists(at: url))
    }

    func test_createFile_success() throws {
        let url = fileManager.temporaryDirectory
            .appendingPathComponent("file")
        XCTAssertNoThrow(try fileManager.createFile(at: url, content: Data("".utf8)))
        try fileManager.deleteFile(at: url)
    }

    func test_createFile_failure() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .deletingLastPathComponent()
            .appendingPathComponent("file")
        XCTAssertThrowsError(try fileManager.createFile(at: url, content: Data("".utf8)))
    }

    func test_createFolder_success() throws {
        let url = fileManager.temporaryDirectory
            .appendingPathComponent("folder")
        XCTAssertNoThrow(try fileManager.createFolder(at: url))
        try fileManager.deleteFolder(at: url)
    }

    func test_createFolder_failure() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .deletingLastPathComponent()
            .appendingPathComponent("folder")
        XCTAssertThrowsError(try fileManager.createFolder(at: url))
    }

    func test_deleteFile_success() throws {
        let url = fileManager.temporaryDirectory
            .appendingPathComponent("file")
        try fileManager.createFile(at: url, content: Data("".utf8))
        XCTAssertNoThrow(try fileManager.deleteFile(at: url))
    }

    func test_deleteFile_failure() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .deletingLastPathComponent()
            .appendingPathComponent("file")
        XCTAssertThrowsError(try fileManager.deleteFile(at: url))
    }

    func test_deleteFolder_success() throws {
        let url = fileManager.temporaryDirectory
            .appendingPathComponent("folder")
        try fileManager.createFolder(at: url)
        XCTAssertNoThrow(try fileManager.deleteFolder(at: url))
    }

    func test_deleteFolder_failure() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .deletingLastPathComponent()
            .appendingPathComponent("folder")
        XCTAssertThrowsError(try fileManager.deleteFolder(at: url))
    }

    func test_verifyFileExisting_success() throws {
        let url = fileManager.temporaryDirectory
            .appendingPathComponent("file")
        try fileManager.createFile(at: url, content: Data("".utf8))
        XCTAssertNoThrow(try fileManager.verifyFileExisting(at: url))
        try fileManager.deleteFile(at: url)
    }

    func test_verifyFileExisting_failure() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .deletingLastPathComponent()
            .appendingPathComponent("file")
        XCTAssertThrowsError(try fileManager.verifyFileExisting(at: url))
    }

    func test_verifyFolderExisting_success() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent("folder")
        try fileManager.createFolder(at: url)
        XCTAssertNoThrow(try fileManager.verifyFolderExisting(at: url))
        try fileManager.deleteFolder(at: url)
    }

    func test_verifyFolderExisting_failure() throws {
        let url = fileManager.homeDirectoryForCurrentUser
            .deletingLastPathComponent()
            .appendingPathComponent("folder")
        XCTAssertThrowsError(try fileManager.verifyFolderExisting(at: url))
    }
}
