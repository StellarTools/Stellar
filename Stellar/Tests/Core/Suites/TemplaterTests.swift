//  TemplaterTests.swift

import XCTest
@testable import StellarCore

final class TemplaterTests: XCTestCase {

    private var fileManager: FileManaging!
    private var templatingContext: TemplatingContext!
    private var templater: Templater!

    override func setUp() {
        super.setUp()
        fileManager = MockFileManager()
        templatingContext = TemplatingContextFactory().makeTemplatingContext(name: "Stellar")
        templater = Templater(fileManager: fileManager, templatingContext: templatingContext)
    }

    override func tearDown() {
        fileManager = nil
        templatingContext = nil
        templater = nil
        super.tearDown()
    }

    func test_templateFile() throws {
        let source = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
        let destination = source.deletingPathExtension()
        XCTAssertFalse(fileManager.fileExists(at: destination))
        try templater.templateFile(source: source, destination: destination)
        XCTAssertTrue(fileManager.fileExists(at: destination))
    }

    func test_templateFile_notATemplate() throws {
        let source = Bundle.module.url(forResource: "README", withExtension: "md", subdirectory: "Resources")!
        let destination = source.deletingPathExtension()
        XCTAssertFalse(fileManager.fileExists(at: destination))
        XCTAssertThrowsError(try templater.templateFile(source: source, destination: destination))
        XCTAssertFalse(fileManager.fileExists(at: destination))
    }

    func test_templateFolder() throws {
        let source = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
            .deletingLastPathComponent()

        var destinations = [URL]()

        let enumerator = fileManager.enumerator(at: source)!
        while let templateLocation = enumerator.nextObject() as? URL {
            guard templateLocation.pathExtension == "stencil" else { continue }
            destinations.append(templateLocation)
        }

        let destination = source // this is ok since we use a mock FileManager

        try fileManager.createFolder(at: destination)

        for dstination in destinations {
            XCTAssertFalse(fileManager.fileExists(at: dstination))
        }
        try templater.templateFolder(source: source, destination: destination)

        for dstination in destinations {
            XCTAssertTrue(fileManager.fileExists(at: dstination.deletingPathExtension()))
        }
    }
}
