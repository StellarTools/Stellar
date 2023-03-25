// LogEventFormatters+XCode.swift

import Foundation

public final class XCodeLogEventFormatter: LogEventMessageFormatter {
    
    public func format(event: Log.Event) -> LogSerializableData? {
        event.message.stringValue
    }
    
}
