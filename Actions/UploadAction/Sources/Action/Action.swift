//  UploadAction.swift

public struct UploadAction {
    
    private var argument: String
    
    public init(argument: String) {
        self.argument = argument
    }
    
    public func call() {
        print("UploadAction called with argument 'argument' of value '\(argument)'.")
    }
}
