//  ScanAction.swift

public class ScanAction: ActionProtocol {
    public typealias Configuration = ScanActionConfiguration
    
    // MARK: - Properties
    
    public static var configType = ScanActionConfiguration.self
    
    // MARK: - Initialization
    
    public init() {}

    // MARK: - Execute Action

    public func run(config: ScanActionConfiguration) throws {
        print("Now executing ScanAction with configuration:")
        print("\t- Project: \(config.project ?? "")")
        print("\t-  Scheme: \(config.scheme ?? "")")
        print("\t-   XCode: \(config.version ?? "")")
    }
}

// MARK: - ScanActionConfiguration

/// Defines custom collection of options for scan action.
public class ScanActionConfiguration: ActionConfigurationProtocol {
    
    @ActionParam(environment: "XCODE_PROJECT", required: true)
    public var project: String?
   
    @ActionParam(environment: "XCODE_SCHEME", required: true)
    public var scheme: String?
    
    @ActionParam(environment: "XCODE_VERSION", defaultValue: "14.3", required: false)
    public var version: String?
    
    required public init() { }
    
}

