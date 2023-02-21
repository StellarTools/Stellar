//  TemplatingContextFactory.swift

import Foundation

struct TemplatingContextFactory {
    
    private struct TemplateConstants {
        static let name = "name"
        static let url = "url"
    }
    
    func makeTemplatingContext(name: String) -> TemplatingContext {
        [
            TemplateConstants.name: name
        ]
    }
    
    func makeTemplatingContext(name: String, url: String) -> TemplatingContext {
        [
            TemplateConstants.name: name,
            TemplateConstants.url: url
        ]
    }
}
