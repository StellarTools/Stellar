//  TemplateRenderer.swift

import Foundation
import PathKit
import Stencil
import StencilSwiftKit

final class TemplateRenderer {
    
    private let templateLocation: URL
    
    init(templateLocation: URL) {
        self.templateLocation = templateLocation
    }
    
    func renderTemplate(with context: TemplatingContext) throws -> RenderedTemplate {
        let environment = makeEnvironment()
        let filename = templateLocation.lastPathComponent
        return try environment.renderTemplate(name: filename, context: context)
    }
    
    private func makeEnvironment() -> Environment {
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        let templateFolder = templateLocation.deletingLastPathComponent().path
        let fsLoader = FileSystemLoader(paths: [PathKit.Path(stringLiteral: templateFolder)])
        var environment = Environment(loader: fsLoader, extensions: [ext])
        environment.trimBehaviour = .nothing
        return environment
    }
}
