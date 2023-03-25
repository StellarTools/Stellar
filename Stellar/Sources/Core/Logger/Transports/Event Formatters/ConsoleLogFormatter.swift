// ConsoleLogFormatter.swift

import Foundation

public final class ConsoleLogFormatter: LogEventMessageFormatter {
    
    public func format(event: Log.Event) -> LogSerializableData? {
        event.message.stringValue
    }
    
}
