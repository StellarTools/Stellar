// LogTransports+Console.swift

import Foundation

/// A console log printer used when debugging on XCode.
public final class ConsoleLogTransport: LogTransport {
    
    // MARK: - Public Properties
    
    public var isEnabled = true
    public var minimumAcceptedLevel: Log.Level? = nil

    public let queue: DispatchQueue
    public let formatters: [LogEventMessageFormatter]
    
    // MARK: - Initialization
    
    /// Initialize a new console transport.
    ///
    /// - Parameter formatters: formatters used to transform an event to its serialized representation.
    init(formatters: [LogEventMessageFormatter] = [XCodeLogEventFormatter()]) {
        self.queue = DispatchQueue(label: String(describing: type(of: self)), attributes: [])
        self.formatters = formatters
    }
    
    // MARK: - Public Methods
    
    public func record(event: Log.Event) -> Bool {
        guard let message = formatters.format(event: event)?.asString(),
              message.isEmpty == false else {
            return false
        }
        
        print(message)
        return true
    }
    
}

