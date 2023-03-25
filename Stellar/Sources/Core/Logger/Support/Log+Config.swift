// Log+Config.swift

import Foundation

extension Logger {
    
    // MARK: - Config
    
    /// Configuration settings for a new log instance.
    public struct Config {
        
        // MARK: - Public Properties
        
        /// Subsystem is typically the bundle identifier of the framework.
        public var subsystem = ""
        
        /// Used to further distinguish a logger inside the same `subsystem`.
        public var category = ""
        
        /// Identify how the messages must be handled when sent to the logger instance.
        /// By default is set to `true` when running un debug, `false` on release.
        ///
        /// In synchronous mode messages are sent directly to the queue and the log function is returned
        /// when recorded is called on each specified transport. This mode is is helpful while debugging,
        /// as it ensures that logs are always up-to-date when debug breakpoints are hit.
        ///
        /// However, synchronous mode can have a negative influence on performance and is
        /// therefore not recommended for use in production code.
        public var isSynchronous: Bool
        
        /// Enable or disable logging.
        /// Disabled loggers ignore all received messages regardless their severity level.
        public var isEnabled = true
        
        /// Minimum accepted severity level.
        public var level: Level = .debug
        
        /// Used to decide whether a given event should be passed along to the receiver transports.
        public var filters = [LogTransportFilter]()
        
        /// List of underlying transport layers which can receive and eventually store messages payload (`Event`).
        public var transports = [LogTransport]()
        
        // MARK: - Initialization
        
        /// Create a new configuration.
        ///
        /// - Parameter builder: builder of the configuration.
        public init(_ builder: ((inout Config) -> Void)) {
            self.isSynchronous = isRunningInDebug()
            builder(&self)
        }
        
    }
    
}
