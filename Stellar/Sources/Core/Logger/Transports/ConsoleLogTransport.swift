// LogTransports+Console.swift

import Foundation

/// A console log printer used when debugging on XCode.
public final class ConsoleLogTransport: LogTransport {
    
    // MARK: - Public Properties
    
    public var isEnabled = true
    public var minimumAcceptedLevel: Logger.Level? = nil

    public let queue: DispatchQueue
    public let formatters: [LogEventMessageFormatter]
    
    // MARK: - Initialization
    
    /// Initialize a new console transport.
    ///
    /// - Parameter formatters: Formatters used to transform an event to its serialized representation.
    ///                         If not set, it will be chosen automatically based on the release mode.
    init(formatters: [LogEventMessageFormatter]? = nil) {
        self.queue = DispatchQueue(label: String(describing: type(of: self)), attributes: [])
        self.formatters = formatters ?? [(isRunningInDebug() ? XCodeLogFormatter() : ConsoleLogFormatter())]
    }
    
    // MARK: - Public Methods
    
    public func record(event: Logger.Event) -> Bool {
        guard let message = formatters.format(event: event)?.asString(),
              message.isEmpty == false else {
            return false
        }
        
        print(message)
        return true
    }
    
}

