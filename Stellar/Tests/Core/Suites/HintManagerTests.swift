//  HintManagerTests.swift

import XCTest
@testable import StellarCore

final class HintManagerTests: XCTestCase {
    
    var manager: HintManager!
    
    override func setUp() {
        super.setUp()
        let url = Bundle.stellarCore
            .url(forResource: "Templates", withExtension: "bundle", subdirectory: "Resources")!
            .appendingPathComponent("Hints")
        manager = HintManager(hintTemplatesLocation: url)
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testHintForActionCreated() throws {
        let sut = try manager.hintForActionCreated(name: "TestAction", url: "../Actions/TestAction")
        let er = """


Add the newly created action to the Executor's Package.swift.

    ...
    dependencies: [
        ...
        .package(path: "../Actions/TestAction")
        ...
    ],
    ...
    targets: [
        ...
        .target(
            ...
            dependencies: [
                    ...
                    .product(name: "TestAction", package: "TestAction"),
                    ...
            ])
            ...
    ]
    ...

"""
        XCTAssertEqual(sut, er)
    }
}
