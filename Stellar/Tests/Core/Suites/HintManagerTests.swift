//  HintManagerTests.swift

import XCTest
@testable import StellarCore

final class HintManagerTests: XCTestCase {
    
    private var hintManager: HintManager!
    
    private let hintTemplatesUrl = Bundle.stellarCore
        .url(forResource: "Templates", withExtension: "bundle", subdirectory: "Resources")!
        .appendingPathComponent("Hints")
    
    override func setUp() {
        super.setUp()
        hintManager = HintManager(hintTemplatesLocation: hintTemplatesUrl)
    }
    
    override func tearDown() {
        hintManager = nil
        super.tearDown()
    }
    
    func testHintForActionCreated() throws {
        let nameValue = "TestAction"
        let urlValue = "../Actions/TestAction"
        let hint = try hintManager.hintForActionCreated(name: nameValue, url: urlValue)
        let createdActionHintTemplate = hintTemplatesUrl
            .appendingPathComponent("ActionCreated")
            .appendingPathExtension("stencil")
        let expected = try String(contentsOf: createdActionHintTemplate)
        .replacingOccurrences(of: "{{ name }}", with: nameValue)
        .replacingOccurrences(of: "{{ url }}", with: urlValue)
        XCTAssertEqual(hint, expected)
    }
}
