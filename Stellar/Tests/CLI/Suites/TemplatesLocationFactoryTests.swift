//  TemplatesLocationFactoryTests.swift

import XCTest
@testable import StellarCLI

final class TemplatesLocationFactoryTests: XCTestCase {
    
    private var fileManager: FileManaging!
    private let customTemplatesLocation = "MyTemplates"
    
    override func setUpWithError() throws {
        fileManager = MockFileManager()
    }
    
    override func tearDownWithError() throws {
        fileManager = nil
    }
    
    func test_actionTemplatesLocation_defaultTemplatesLocation() throws {
        let templatesLocationFactory = TemplatesLocationFactory(fileManager: fileManager)
        let result = templatesLocationFactory.actionTemplatesLocation
        let expected = fileManager.executableLocation
            .appendingPathComponent(PathConstants.templatesBundle)
            .appendingPathComponent(TemplatesLocationFactory.Folder.action)
        XCTAssertEqual(result, expected)
    }
    
    func test_actionTemplatesLocation_customTemplatesLocation() throws {
        let templatesLocationFactory = TemplatesLocationFactory(templatesPath: customTemplatesLocation, fileManager: fileManager)
        let result = templatesLocationFactory.actionTemplatesLocation
        let expected = URL(fileURLWithPath: customTemplatesLocation)
            .appendingPathComponent(TemplatesLocationFactory.Folder.action)
        XCTAssertEqual(result, expected)
    }
    
    func test_executorTemplatesLocation_defaultTemplatesLocation() throws {
        let templatesLocationFactory = TemplatesLocationFactory(fileManager: fileManager)
        let result = templatesLocationFactory.executorTemplatesLocation
        let expected = fileManager.executableLocation
            .appendingPathComponent(PathConstants.templatesBundle)
            .appendingPathComponent(TemplatesLocationFactory.Folder.executor)
        XCTAssertEqual(result, expected)
    }
    
    func test_executorTemplatesLocation_customTemplatesLocation() throws {
        let templatesLocationFactory = TemplatesLocationFactory(templatesPath: customTemplatesLocation, fileManager: fileManager)
        let result = templatesLocationFactory.executorTemplatesLocation
        let expected = URL(fileURLWithPath: customTemplatesLocation)
            .appendingPathComponent(TemplatesLocationFactory.Folder.executor)
        XCTAssertEqual(result, expected)
    }
    
    func test_taskTemplatesLocation_defaultTemplatesLocation() throws {
        let templatesLocationFactory = TemplatesLocationFactory(fileManager: fileManager)
        let result = templatesLocationFactory.taskTemplatesLocation
        let expected = fileManager.executableLocation
            .appendingPathComponent(PathConstants.templatesBundle)
            .appendingPathComponent(TemplatesLocationFactory.Folder.task)
        XCTAssertEqual(result, expected)
    }
    
    func test_taskTemplatesLocation_customTemplatesLocation() throws {
        let templatesLocationFactory = TemplatesLocationFactory(templatesPath: customTemplatesLocation, fileManager: fileManager)
        let result = templatesLocationFactory.taskTemplatesLocation
        let expected = URL(fileURLWithPath: customTemplatesLocation)
            .appendingPathComponent(TemplatesLocationFactory.Folder.task)
        XCTAssertEqual(result, expected)
    }
}
