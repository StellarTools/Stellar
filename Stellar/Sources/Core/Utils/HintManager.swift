//  HintManager.swift

import Foundation
import PathKit

typealias TemplateFilename = String

class HintManager {
    
    /// Renders an hint with a given the template and context
    /// - Parameters:
    ///   - template: the template name
    ///   - context: the template context that should replace the placeholder variables
    /// - Returns: A rendered text or an Exception.
    private func renderHint(using template: TemplateFilename, context: TemplatingContext) throws -> String {
        let hintLocation = URLManager().hintFolderLocation().appendingPathComponent(template, isDirectory: false)
        let templateRenderer = TemplateRenderer(templateLocation: hintLocation)
        return try templateRenderer.renderTemplate(with: context)
    }
    
    /// Renders the hint for Anctions created on the default path with a given the template and context
    /// - Parameters:
    ///   - name: the name of the Action
    /// - Returns: The rendered text or an Exception.
    func hintForActionCreatedOnDefaultPath(with name: String) throws -> String {
        let context = TemplatingContextFactory().makeTemplatingContext(name: name)
        return try renderHint(using: HintTemplateNames.actionCreatedOnDefaultPath, context: context)
    }
    
}
