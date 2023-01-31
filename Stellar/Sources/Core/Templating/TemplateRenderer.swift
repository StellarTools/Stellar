//  TemplateRenderer.swift

import Foundation
import PathKit
import Stencil
import StencilSwiftKit

final class TemplateRenderer {
    
    private let templatePath: String
    
    init(templatePath: String) {
        self.templatePath = templatePath
    }
    
    func renderTemplate(with context: TemplatingContext) throws -> RenderedTemplate {
        let environment = makeEnvironment()
        let filename = URL(fileURLWithPath: templatePath).lastPathComponent
        return try environment.renderTemplate(name: filename, context: context)
    }
    
    private func makeEnvironment() -> Environment {
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        let templateFolder = URL(fileURLWithPath: templatePath).deletingLastPathComponent().path
        let fsLoader = FileSystemLoader(paths: [PathKit.Path(stringLiteral: templateFolder)])
        var environment = Environment(loader: fsLoader, extensions: [ext])
        environment.trimBehaviour = .nothing
        return environment
    }
}
