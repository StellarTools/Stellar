// LogEventMessageFormatter.swift

import Foundation

// MARK: - LogEventMessageFormatter

/// Protocol used to format the message text of the `Log.Event`.
public protocol LogEventMessageFormatter {
    
    /// Create a string representation of the passed event.
    ///
    /// - Returns: serializable representation of the event
    func format(event: Log.Event) -> LogSerializableData?
    
}

// MARK: - LogEventMessageFormatter Extension

extension [LogEventMessageFormatter] {
    
    func format(event: Log.Event) -> LogSerializableData? {
        for formatter in self {
            if let formattedString = formatter.format(event: event) {
                return formattedString
            }
        }
        
        return nil
    }
    
}


// MARK: - LogSerializableData

/// Any data which can be serialized by a log transport.
public protocol LogSerializableData {
    
    func asString() -> String?
    func asData() -> Data?
    
}

extension Data: LogSerializableData {
    
    public func asData() -> Data? {
        self
    }
    
    public func asString() -> String? {
        String(data: self, encoding: .utf8)
    }
    
}

extension String: LogSerializableData {
    
    public func asString() -> String? {
        self
    }
    
    public func asData() -> Data? {
        self.data(using: .utf8)
    }
    
}
