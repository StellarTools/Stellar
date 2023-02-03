//  StencilResourcesTests.swift

import XCTest
@testable import Stellar

final class StencilResourcesTests: XCTestCase {
    func testHintForActionCreatedOnDefaultPath() throws {
        let sut = try HintManager().hintForActionCreatedOnDefaultPath(with: "TestAction")
        let er = """


Add the newly created action to the Executor's Package.swift.

    ...
    dependencies: [
        ...
        .package(path: "../../Actions/TestAction")
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

Bye 🙂

"""
        XCTAssert(sut == er)
    }
}
