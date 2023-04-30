//  UploadAction.swift

import StellarActionCore
import ScanAction

public struct UploadAction: ActionProtocol {
    
    // MARK: - Properties
    
    public static var configType = UploadActionConfiguration.self
    
    @Environment(name: "XCODE_WHATEVER")
    public var whateverEnv: String?
    
    @Environment(name: "XCODE_PROJECT")
    public var projectEnv: String?
   
    // MARK: - Initialization
    
    public init() {}

    // MARK: - Execute Action

    public func run(config: Configuration) throws {
        
        let scanAction = ScanAction()
        let scanConfiguration = ScanActionConfiguration()
        
        scanConfiguration.project = "Initial_project"
        scanConfiguration.scheme = "Initial_scheme"
        scanConfiguration.version = "Initial_version"

        try scanAction.run(config: scanConfiguration)
        
        print("Now executing UploadAction with configuration:")
        print("\t- Whatever: \(config.whatever ?? "")")
        
        print("Now executing UploadAction enviroment print:")
        print("\t- whateverEnv: \(whateverEnv ?? "")")
        print("\t-  projectEnv: \(projectEnv ?? "")")

    }
    
}
