//  ScanAction.swift

import StellarActionCore

public struct ScanAction: ActionProtocol {
    
    // MARK: - Properties
    
    public static var configType = ScanActionConfiguration.self
        
    @Environment(name: "XCODE_PROJECT")
    var projectEnv: String?
    
    @Environment(name: "XCODE_SCHEME")
    var schemeEnv: String?
    
    @Environment(name: "XCODE_VERSION")
    var versionEnv: String?
    
    // MARK: - Initialization
    
    public init() {}

    // MARK: - Execute Action

    public func run(config: Configuration) throws {
        print("Now executing ScanAction with configuration:")
        print("\t- Project: \(config.project ?? "")")
        print("\t-  Scheme: \(config.scheme ?? "")")
        print("\t-   XCode: \(config.version ?? "")")
        
        config.project = "TestTestTest"
        
        print("\t-    projectEnv: \(projectEnv ?? "")")
        print("\t-     projectEnv: \(schemeEnv ?? "")")
        print("\t-      projectEnv: \(versionEnv ?? "")")

    }
}
