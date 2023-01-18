//
//  File.swift
//  
//
//  Created by Alberto De Bortoli on 16/01/2023.
//

import ArgumentParser
import Foundation

extension ParsableCommand {
    
    func templatesLocation(_ templates: String?) -> URL {
        if let templates = templates {
            return URL(fileURLWithPath: templates)
        }
        return URL(fileURLWithPath: CommandLine.arguments.first!)
            .deletingLastPathComponent()
            .appendingPathExtension(FolderConstants.templatesFolder)
    }
}
