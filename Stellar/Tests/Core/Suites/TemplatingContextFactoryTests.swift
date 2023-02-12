//  TemplatingContextFactoryTests.swift

import XCTest
@testable import StellarCore

final class TemplatingContextFactoryTests: XCTestCase {

    private let sut = TemplatingContextFactory()

    func testExample() throws {
        let context = sut.makeTemplatingContext(name: "Stellar")
        let expected = ["name": "Stellar"]
        XCTAssertEqual(context, expected)
    }
}
