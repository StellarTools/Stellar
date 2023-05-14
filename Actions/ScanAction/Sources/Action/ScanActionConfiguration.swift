//  ScanActionConfiguration.swift

import Foundation
import StellarActionCore

/// Defines custom collection of options for scan action.
public struct ScanActionConfiguration: ActionConfigurationProtocol {
    
    @ActionParam(environment: "XCODE_PROJECT", required: true)
    public var project: String?
   
    @ActionParam(environment: "XCODE_SCHEME", required: true)
    public var scheme: String?
    
    @ActionParam(environment: "XCODE_VERSION", defaultValue: "14.3", required: false)
    public var version: String?
    
    public init() { }
    
}
