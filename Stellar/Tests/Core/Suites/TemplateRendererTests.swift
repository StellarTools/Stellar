//  TemplateRendererTests.swift

import XCTest
@testable import StellarCore

final class TemplateRendererTests: XCTestCase {

    func test_renderTemplate() throws {
        let url = Bundle.module.url(forResource: "README.md", withExtension: "stencil", subdirectory: "Resources")!
        let renderer = TemplateRenderer(templateLocation: url)
        let renderedTemplate = try renderer.renderTemplate(with: ["name": "Stellar"])
        let expected = try String(contentsOf: url).replacingOccurrences(of: "{{ name }}", with: "Stellar")
        XCTAssertEqual(renderedTemplate, expected)
    }
}
