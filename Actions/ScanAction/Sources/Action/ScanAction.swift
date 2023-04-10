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
        print("- Project: \(config.project ?? "")")
        print("-  Scheme: \(config.scheme ?? "")")
        print("-   XCode: \(config.version ?? "")")
    }
}

// MARK: - ScanActionConfiguration

public class ScanActionConfiguration: ActionConfigurationProtocol {
    
    @ActionParam(environment: "XCODE_PROJECT", required: true)
    public var project: String?
   
    @ActionParam(environment: "XCODE_SCHEME", required: true)
    public var scheme: String?
    
    @ActionParam(environment: "XCODE_VERSION", defaultValue: "14.3", required: false)
    public var version: String?
    
    required public init() { }
    
}

