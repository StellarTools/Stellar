//  String+DeletePrefixTests.swift

import XCTest
@testable import StellarCore

final class String_DeletePrefixTests: XCTestCase {

    func test_deleteExistingPrefix() throws {
        XCTAssertEqual("Some content".deletingPrefix("Some "), "content")
    }

    func test_deleteNonExistingPrefix() throws {
        XCTAssertEqual("Some content".deletingPrefix("some "), "Some content")
    }
}
