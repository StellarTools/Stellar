//  StencilResourcesTests.swift

import XCTest
@testable import StellarCore

final class StencilResourcesTests: XCTestCase {
    
    private var fileManager: FileManaging!

    override func setUp() {
        super.setUp()
        fileManager = MockFileManager(currentLocation: Bundle.module.resourceURL!)
    }
    
    override func tearDownWithError() throws {
        fileManager = nil
    }
    
    func testHintForActionCreatedOnDefaultPath() throws {
        
        let hint = try HintManager(fileManager: fileManager).hintForActionCreatedOnDefaultPath(with: "TestPath", name: "TestAction")
        XCTAssert(!hint.isEmpty)
        
        let unresolvedVariable = hint.range(of: #"\{\{\s{1}\S*[^\{\}]\s{1}\}\}"#, options: .regularExpression) == .none
        XCTAssert(unresolvedVariable)
        
    }
}
