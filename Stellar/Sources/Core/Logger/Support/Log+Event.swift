// Log+Event.swift

import Foundation

extension Log {
    
    // MARK: - Event
    
    /// When a new message is sent to a logger a new payload (`Event`) is created automatically.
    /// It contains the description of the message along with other metadata.
    public struct Event {
        public typealias Metadata = [String: String?]
        
        // MARK: - Public Properties
        
        /// Message content.
        public let message: TerminalRepresentable
        
        /// Additional metadata dictionary.
        public let extra: Metadata?
        
        /// Stacktrace data.
        public let stacktrace: Stacktrace
        
        /// Parent log who generates the payload.
        public internal(set) weak var log: Log?
        
        /// Subsystem.
        public internal(set) var subsystem: String?
        
        /// Category.
        public internal(set) var category: String?
        
        /// Severity level of the payload.
        public internal(set) var level: Level = .debug
        
        // MARK: - Initialization
        
        /// Initialize a new message with a given string.
        ///
        /// - Parameters:
        ///   - message: content of the message.
        ///   - extra: extra informations.
        ///   - stacktrace: stacktrace informations.
        init(_ message: TerminalRepresentable = "", extra: Metadata? = nil, stacktrace: Stacktrace) {
            self.message = message
            self.extra = extra
            self.stacktrace = stacktrace
        }
        
    }
    
    // MARK: - Stacktrace
    
    /// A stacktrace contains additional metadata about the origin of the event message.
    public struct Stacktrace {
        
        // MARK: - Public Properties
        
        /// Function name.
        public private(set) var function: String?
        
        /// Origin file path.
        public private(set) var filePath: String?
        
        /// Origin file name.
        public var fileName: String? {
            ((filePath ?? "") as NSString).lastPathComponent
        }
        
        /// File line.
        public private(set) var fileLine: Int?
        
        /// Calling thread id.
        public private(set) var threadID: UInt64
        
        // MARK: - Private Properties
        
        private static let threadID: UInt64 = {
            var threadID: UInt64 = 0
            pthread_threadid_np(nil, &threadID)
            return threadID
        }()
        
        // MARK: - Initialization
        
        init(function: String?, filePath: String?, fileLine: Int?) {
            self.function = function
            self.filePath = filePath
            self.fileLine = fileLine
            self.threadID = Stacktrace.threadID
        }
        
    }
}
