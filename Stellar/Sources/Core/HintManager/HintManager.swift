//  HintManager.swift

import Foundation
import PathKit

class HintManager {

    struct HintTemplateNames {
        static let actionCreated = "ActionCreated.stencil"
    }
    
    private let hintTemplatesLocation: URL
    
    init(hintTemplatesLocation: URL) {
        self.hintTemplatesLocation = hintTemplatesLocation
    }
    
    /// Renders the 'ActionCreated" hint template.
    /// - Parameters:
    ///   - name: the name of the Action
    /// - Returns: The rendered template
    func hintForActionCreated(name: String, url: String) throws -> String {
        let context = TemplatingContextFactory().makeTemplatingContext(name: name, url: url)
        return try renderHint(using: HintTemplateNames.actionCreated, context: context)
    }
    
    /// Renders a given hint template using a context.
    /// - Parameters:
    ///   - template: the template name
    ///   - context: the template context that should replace the placeholder variables
    /// - Returns: A rendered template
    private func renderHint(using template: String, context: TemplatingContext) throws -> String {
        let hintLocation = hintTemplatesLocation.appendingPathComponent(template, isDirectory: false)
        let templateRenderer = TemplateRenderer(templateLocation: hintLocation)
        return try templateRenderer.renderTemplate(with: context)
    }
}
