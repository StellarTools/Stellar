//  URLManagerTests.swift

import XCTest
@testable import StellarCLI

final class URLManagerTests: XCTestCase {

    private var urlManager: URLManager!
    private let fileManager = MockFileManager()
    
    override func setUp() async throws {
        urlManager = URLManager(fileManager: fileManager)
    }
    
    func test_templatesLocation() throws {
        let url = urlManager.templatesLocation(nil)
        let expected = fileManager.currentLocation.appendingPathComponent(FolderConstants.templatesFolder)
        XCTAssertEqual(url, expected)
    }
    
    func test_templatesLocation_customLocation() throws {
        let templates = "MyTemplates"
        let url = urlManager.templatesLocation(templates)
        let expected = URL(fileURLWithPath: templates)
        XCTAssertEqual(url, expected)
    }
}
