//  HintManager.swift

import Foundation
import PathKit
import Stencil
import StencilSwiftKit

class HintManager {
    
    /// Searches the well know folder to find a string template and renders the stencil with the given context
    /// - Parameters:
    ///   - templateName: the stencil name
    ///   - context: the stencil context that should replace the stencil vairables
    /// - Returns: A stencil template rendered as a string or an Exception.
    private func loadStencilString(_ templateName: String, context: [String: String]) throws -> String {
        // to be replaced with common 'templatesLocation'
        let templatesLocation = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let templateURL = templatesLocation
            .appendingPathComponent("Stellar", isDirectory: true)
            .appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("Strings", isDirectory: true)
            .appendingPathComponent("Hints", isDirectory: true)
            .appendingPathComponent(templateName, isDirectory: false)

        let templateRenderer = TemplateRenderer(templatePath: templateURL.path)
        return try templateRenderer.renderTemplate(with: context)
    }
    
    /// Searches the well know folder to find a string template and renders the stencil with the given context
    /// - Parameters:
    ///   - templateName: the stencil name
    ///   - context: the stencil context that should replace the stencil vairables
    /// - Returns: A stencil template rendered as a string or an Exception.
    func hintForActionCreatedOnDefaultPath(with name: String) throws -> String {
        return try loadStencilString(HintTemplateNames.actionCreatedOnDefaultPath, context: [TemplateConstants.name: name])
    }
    
}
