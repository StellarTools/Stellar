//  UploadAction.swift

import StellarActionCore

public struct UploadAction: ActionProtocol {
    
    // MARK: - Properties
    
    public static var configType = UploadActionConfiguration.self
    
    @ActionParam(environment: "XCODE_WHATEVER", required: true)
    public var whatever: String?
   
    // MARK: - Initialization
    
    public init() {}

    // MARK: - Execute Action

    public func run(config: Configuration) throws {
        print("Now executing ScanAction with configuration:")
        print("\t- Whatever: \(config.whatever ?? "")")

    }
    
}
