// XCodeLogFormatter.swift

import Foundation

public final class XCodeLogFormatter: LogEventMessageFormatter {
            
    public func format(event: Log.Event) -> LogSerializableData? {
        switch event.message {
        case let table as ASCIITable:
            return "\(event.timestamp.iso8601)\n\(table.stringValue)"
        default:
            return "\(event.timestamp.iso8601, pad: .left(25))\(event.level.shortDescription) \(event.message.stringValue)"
        }
    }
    
}

// MARK: - Date Extension

private extension Date {
    
    private static let isoFormatter = ISO8601DateFormatter()
    
    var iso8601: String {
        Date.isoFormatter.string(from: self)
    }
    
}
