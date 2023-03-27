// ConsoleLogFormatter.swift

import Foundation

public final class ConsoleLogFormatter: LogEventMessageFormatter {
    
    public func format(event: Logger.Event) -> LogSerializableData? {
        event.message.stringValue
    }
    
}
