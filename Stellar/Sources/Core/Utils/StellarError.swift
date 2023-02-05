import Foundation

public struct StellarError: LocalizedError {
    
    public enum Kind: String {
        case `internal`
        case network
    }
    
    public let reason: String?
    public let kind: Kind
    public var userInfo: [AnyHashable: Any?]
    
    public init(_ kind: Kind = .internal,
                reason: String? = nil,
                userInfo: [AnyHashable: Any?] = [:]) {
        self.kind = kind
        self.reason = reason
        self.userInfo = userInfo
    }
        
    public var errorDescription: String? {
        return reason ?? kind.rawValue
    }

}
