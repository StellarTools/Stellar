// SampleAction.swift

public struct SampleAction {
    
    private var argument: String
    
    public init(argument: String) {
        self.argument = argument
    }
    
    public func call() {
        print("Sample Action called with argument 'argument' of value '\(argument)'.")
    }
}
