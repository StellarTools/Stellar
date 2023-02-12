//  WriterTests.swift

import XCTest
@testable import StellarCore

final class WriterTests: XCTestCase {

    private var fileManager: MockFileManager!
    private let content = "Some content"
    private let location = URL(fileURLWithPath: "tmp/filename.ext")

    override func setUpWithError() throws {
        fileManager = MockFileManager()
    }

    override func tearDownWithError() throws {
        fileManager = nil
    }

    func test_fileAlreadyExists() throws {
        let writer = Writer(fileManager: fileManager)
        fileManager.files[location] = Data(content.utf8)
        XCTAssertThrowsError(try writer.write(content: content, to: location), "", { error in
            XCTAssertEqual(error as! Writer.WriterError, Writer.WriterError.existingFile(location))
        })
    }

    func test_contentIsWrittenToFile() throws {
        let writer = Writer(fileManager: fileManager)
        fileManager.files[location] = nil
        XCTAssertNoThrow(try writer.write(content: content, to: location))
        XCTAssertEqual(fileManager.files[location], Data(content.utf8))
    }
}
