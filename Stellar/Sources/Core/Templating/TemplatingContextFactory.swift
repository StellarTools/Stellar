//  TemplatingContextFactory.swift

import Foundation

struct TemplatingContextFactory {
    
    private struct TemplateConstants {
        static let name = "name"
    }
    
    func makeTemplatingContext(name: String) -> TemplatingContext {
        [
            TemplateConstants.name: name
        ]
    }
}
