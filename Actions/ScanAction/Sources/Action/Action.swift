//  ScanAction.swift

public struct ScanAction {
    
    private var argument: String
    
    public init(argument: String) {
        self.argument = argument
    }
    
    public func call() {
        print("ScanAction called with argument 'argument' of value '\(argument)'.")
    }
}
