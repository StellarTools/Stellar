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
    private func loadStencilString(_ templateName: String, context: [String: Any]) throws -> String {
        // to be replaced with common 'templatesLocation'
        let templatesLocation = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        // Stellar/Templates/Resources/Strings/Hints
        let templateURL = templatesLocation
            .appendingPathComponent(FolderConstants.stellarFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.templatesFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.resourcesFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.stringsFolder, isDirectory: true)
            .appendingPathComponent(FolderConstants.hintsFolder, isDirectory: true)
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
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        return try loadStencilString(HintTemplateNames.actionCreatedOnDefaultPath, context: context)
    }
    
}
