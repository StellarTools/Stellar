//  FatalError.swift

import Foundation

public enum ErrorType {
    case abort
    case bug
    case abortSilent
    case bugSilent
}

public protocol FatalError: LocalizedError, CustomStringConvertible {
    
    var type: ErrorType { get }

}
