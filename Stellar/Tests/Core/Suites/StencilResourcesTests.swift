//  StencilResourcesTests.swift

import XCTest
@testable import StellarCore

final class StencilResourcesTests: XCTestCase {
    
    func testHintForActionCreatedOnDefaultPath() throws {
        
        let hint = try HintManager().hintForActionCreatedOnDefaultPath(with: "TestPath", name: "TestAction")
        XCTAssert(!hint.isEmpty)
        
        let unresolvedVariable = hint.range(of: #"\{\{\s{1}\S*[^\{\}]\s{1}\}\}"#, options: .regularExpression) == .none
        XCTAssert(unresolvedVariable)
        
    }
}
