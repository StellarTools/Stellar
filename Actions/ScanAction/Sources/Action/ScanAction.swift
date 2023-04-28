//  ScanAction.swift

public struct ScanAction: ActionProtocol {
    
    // MARK: - Properties
    
    public static var configType = ScanActionConfiguration.self
    
    // MARK: - Initialization
    
    public init() {}

    // MARK: - Execute Action

    public func run(config: Configuration) throws {
        print("Now executing ScanAction with configuration:")
        print("\t- Project: \(config.project ?? "")")
        print("\t-  Scheme: \(config.scheme ?? "")")
        print("\t-   XCode: \(config.version ?? "")")
    }
}
