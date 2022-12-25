//  Templater.swift

import Foundation
import PathKit
import Stencil
import StencilSwiftKit

typealias Content = String

final class Templater {
    
    let templatePath: String
    
    init(templatePath: String) {
        self.templatePath = templatePath
    }
    
    func renderTemplate(context: [String: Any]) throws -> Content {
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
