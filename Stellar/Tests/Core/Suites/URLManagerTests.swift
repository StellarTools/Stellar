//  URLManagerTests.swift

import XCTest
@testable import StellarCore

final class URLManagerTests: XCTestCase {

    private let urlManager = URLManager()
    private let projectUrl = URL(fileURLWithPath: "/tmp/app/")

    func test_stellarUrl() throws {
        let url = urlManager.dotStellarUrl(at: projectUrl)
        XCTAssertEqual(url.path, "/tmp/app/.stellar")
    }

    func test_packagesUrl() throws {
        let url = urlManager.packagesUrl(at: projectUrl)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Packages")
    }

    func test_executorUrl() throws {
        let url = urlManager.executorPackageUrl(at: projectUrl)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Packages/Executor")
    }

    func test_executorSourcesUrl() throws {
        let url = urlManager.executorPackageSourcesUrl(at: projectUrl)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Packages/Executor/Sources")
    }

    func test_executablesUrl() throws {
        let url = urlManager.executablesUrl(at: projectUrl)
        XCTAssertEqual(url.path, "/tmp/app/.stellar/Executables")
    }
}
