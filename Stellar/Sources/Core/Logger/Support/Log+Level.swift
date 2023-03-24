import Foundation

extension Log {
    
    // MARK: - Level
    
    /// Represent the different log severity levels defined by a logger.
    /// Lower level means an higher severity (`error` is equal to `0`, `debug` equals to `4`)
    public enum Level: Int, Comparable, CaseIterable, CustomStringConvertible {
        case error = 0, warning, info, debug
        
        /// Long identifier of the severity level.
        public var description: String {
            switch self {
            case .debug:    return "debug"
            case .info:     return "info"
            case .warning:  return "warning"
            case .error:    return "error"
            }
        }
        
        /// Short identifier of the severity level.
        public var shortDescription: String {
            switch self {
            case .debug:    return "DEBG"
            case .info:     return "INFO"
            case .warning:  return "WARN"
            case .error:    return "ERRR"
            }
        }
        
        public static func < (lhs: Level, rhs: Level) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        /// `true` if receiver level is less severe than passed `minLevel`.
        ///
        /// - Parameter minLevel: target minimum level.
        /// - Returns: `true` if it's accepted.
        func isAcceptedWithMinimumLevelSet(minLevel: Level?) -> Bool {
            guard let minLevel = minLevel else {
                return true
            }
            return self.rawValue < minLevel.rawValue
        }
        
    }

    
}
