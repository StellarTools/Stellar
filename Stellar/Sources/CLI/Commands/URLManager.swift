//  URLManager.swift

import ArgumentParser
import Foundation

final class URLManager {
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return URL(fileURLWithPath: CommandLine.arguments.first!)
            .deletingLastPathComponent()
            .appendingPathExtension(FolderConstants.templatesFolder)
    }
}
