//  UploadActionConfiguration.swift

import Foundation
import StellarActionCore

/// Defines custom collection of options for scan action.
public struct UploadActionConfiguration: ActionConfigurationProtocol {
    
    @ActionParam(environment: "XCODE_WHATEVER", required: true)
    public var whatever: String?
    
    public init() { }
}
