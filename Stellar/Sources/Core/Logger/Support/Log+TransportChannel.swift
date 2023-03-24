// Log+TransportChannel.swift

import Foundation

// MARK: - Transporter

extension Log {
    
    /// The underlying object used to dispatch events to each log channel.
    final class Transporter {
        
        // MARK: - Private Properties
        
        /// Set dispatch to synchronous mode, useful for debug purposes.
        private let isSynchronous: Bool
        
        /// Acceptance queue for log events.
        private let queue = DispatchQueue(label: "log.transport-manager.queue", attributes: [])
        
        /// Log event filters.
        private var filters = [TransportFilter]()
        
        /// Log transports.
        private var transports = [Transport]()

        // MARK: - Initialization
        
        /// Initialize a new transporter for a given log.
        ///
        /// - Parameter config: parent log configuration.
        init(config: Log.Config) {
            self.isSynchronous = config.isSynchronous
            self.filters = config.filters
            self.transports = config.transports
        }
        
        // MARK: - Internal Methods
        
        /// Dispatch a new event to underlying transports.
        ///
        /// - Parameter event: event to dispatch.
        func write(_ event: inout Event) {
            writeToTransports(event)
        }
        
        // MARK: - Private Methods
        
        private func writeToTransports(_ event: Event) {
            let acceptDispatcher = dispatcherForQueue(queue, synchronous: isSynchronous)
            acceptDispatcher { [weak self] in
                guard let self = self else {
                    return
                }
                
                guard self.filters.canAcceptEvent(event) else {
                    return // event ignored by the filters
                }
                
                for transport in self.transports {
                    let recordDispatcher = self.dispatcherForQueue(transport.queue, synchronous: self.isSynchronous)
                    recordDispatcher {
                        if transport.isEnabled && event.level.isAcceptedWithMinimumLevelSet(minLevel: transport.minimumAcceptedLevel) {
                            transport.record(event: event)
                        }
                    }
                }
            }
        }
        
        private func dispatcherForQueue(_ queue: DispatchQueue, synchronous: Bool) -> (@escaping () -> Void) -> Void {
            let dispatcher: (@escaping () -> Void) -> Void = { block in
                if synchronous {
                    return queue.sync(execute: block)
                } else {
                    return queue.async(execute: block)
                }
            }
            return dispatcher
        }
        
    }
    
}

// MARK: - Channel

extension Log {
    
    /// A channel is a message receiver for a particular `Log`'s severity level.
    public final class Channel {
        
        // MARK: - Private Properties
        
        /// Parent log.
        weak var log: Log?
        
        /// Represented log level.
        let level: Level
        
        // MARK: - Initialization
        
        /// Initialize a new channel with a managed log and represented level.
        ///
        /// - Parameters:
        ///   - log: parent log instance.
        ///   - level: represented channel level severity.
        init(log: Log, level: Level) {
            self.log = log
            self.level = level
        }
     
        // MARK: - Public Methods
        
        /// Create a new event and post into the channel.
        ///
        /// - Parameters:
        ///   - message: message string.
        ///   - extra: extra dictionary information.
        /// - Returns: generated event.
        @discardableResult
        public func write(_ message: @autoclosure @escaping () -> String,
                          extra: Event.Metadata? = nil,
                          function: String = #function, filePath: String = #file, fileLine: Int = #line) -> Event? {
            
            guard let log = log, log.isEnabled else {
                return nil // not enabled
            }

            let stacktrace = Stacktrace(function: function, filePath: filePath, fileLine: fileLine)
            let extra = (self.log?.extra != nil ? self.log!.extra.merge(with: extra) : extra)
            
            // Generate the event and decorate it with the current scope and runtime attributes
            var event = Event(message(), extra: extra, stacktrace: stacktrace)
            event.log = self.log
            event.level = self.level
            event.subsystem = log.subsystem
            event.category = log.category
         
            log.transporter.write(&event)
            return event
        }
        
    }
    
}
