//  TemplatingContextFactoryTests.swift

import XCTest
@testable import StellarCore

final class TemplatingContextFactoryTests: XCTestCase {

    private let sut = TemplatingContextFactory()

    func test_makeTemplatingContextWithName() throws {
        let context = sut.makeTemplatingContext(name: "Stellar")
        let expected = ["name": "Stellar"]
        XCTAssertEqual(context, expected)
    }
    
    func test_makeTemplatingContextWithNameAndUrl() throws {
        let context = sut.makeTemplatingContext(name: "Stellar", url: "../location")
        let expected = ["name": "Stellar", "url": "../location"]
        XCTAssertEqual(context, expected)
    }
}
