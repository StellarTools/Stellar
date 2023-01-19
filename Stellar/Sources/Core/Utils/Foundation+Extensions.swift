//
//  File.swift
//  
//
//  Created by daniele on 19/01/23.
//

import Foundation

extension String {
    
    public var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }
    
}

extension URL {
    
    func glob(_ pattern: String) -> [String] {
        Glob(pattern: appendingPathComponent(pattern).path).paths
    }
}
