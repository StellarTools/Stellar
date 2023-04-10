//  ScanAction.swift

public class ScanAction: ActionProtocol {
    public typealias Configuration = ScanActionOptions
    
    // MARK: - Properties
    
    public static var configType = ScanActionOptions.self
    
    // MARK: - Initialization
    
    public init() {}

    // MARK: - Execute Action

    public func run(config: ScanActionOptions) throws {
        print("Now executing ScanAction with configuration:")
        print("- Workflow: \(config.workflow ?? "")")
        print("-  Project: \(config.project ?? "")")
        print("-    XCode: \(config.xcode ?? "")")
    }
}

// MARK: - ScanActionOptions

public class ScanActionOptions: ActionConfigurationProtocol {
    
    @ActionParam(environment: "WORKFLOW_NAME", required: true)
    public var workflow: String?
   
    @ActionParam(environment: "PROJECT_NAME", required: true)
    public var project: String?
    
    @ActionParam(environment: "XCODE_VERSION", defaultValue: "14.3", required: false)
    public var xcode: String?
    
    required public init() { }
    
}

