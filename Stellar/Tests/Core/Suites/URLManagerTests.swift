//  URLManagerTests.swift

import XCTest
@testable import StellarCore

final class URLManagerTests: XCTestCase {

    private let urlManager = URLManager()
    private let appLocation = URL(fileURLWithPath: "/tmp/app/")

    func test_stellarUrl() throws {
        let url = urlManager.stellarUrl(at: appLocation)
        XCTAssertEqual(url.path, "/tmp/app/.stellar")
    }

    func test_packagesUrl() throws {
        let url = urlManager.packagesUrl(at: appLocation)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Packages")
    }

    func test_executorUrl() throws {
        let url = urlManager.executorUrl(at: appLocation)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Packages/Executor")
    }

    func test_executorSourcesUrl() throws {
        let url = urlManager.executorSourcesUrl(at: appLocation)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Packages/Executor/Sources")
    }

    func test_executablesUrl() throws {
        let url = urlManager.executablesUrl(at: appLocation)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Executables")
    }
}
