//  Templater.swift

import Foundation

struct Templater {
    
    private enum Constants: String {
        case stencil
    }
    
    enum TemplaterError: Error {
        case invalidTemplateFile(URL)
        case invalidTemplatesFolder(URL)
    }
    
    private let fileManager: FileManaging
    private let templatingContext: TemplatingContext
    
    public init(fileManager: FileManaging = FileManager.default, templatingContext: TemplatingContext) {
        self.fileManager = fileManager
        self.templatingContext = templatingContext
    }
    
    func templateFolder(source: URL, destination: URL) throws {
        Logger().log("Creating folder structure at \(destination.relativePath)")
        try fileManager.verifyFolderExisting(at: source)
        try fileManager.verifyFolderExisting(at: destination)
        
        guard let enumerator = fileManager.enumerator(at: source) else {
            throw TemplaterError.invalidTemplatesFolder(source)
        }
        while let templateLocation = enumerator.nextObject() as? URL {
            guard templateLocation.pathExtension == Constants.stencil.rawValue else { continue }
            let filename = templateLocation
                .deletingPathExtension()
                .lastPathComponent
            let subPath = templateLocation
                .deletingLastPathComponent()
                .absoluteString
                .deletingPrefix(source.absoluteString)
            let renderLocation = destination
                .appendingPathComponent(subPath, isDirectory: true)
                .appendingPathComponent(filename, isDirectory: false)
            try templateFile(source: templateLocation, destination: renderLocation)
        }
    }
    
    func templateFile(source: URL, destination: URL) throws {
        Logger().log("Creating \(destination.relativePath)")
        
        guard source.pathExtension == Constants.stencil.rawValue else {
            throw TemplaterError.invalidTemplateFile(source)
        }
        
        let templater = TemplateRenderer(templatePath: source.path)
        let content = try templater.renderTemplate(with: templatingContext)
        try Writer().write(content: content, to: destination)
    }
}
