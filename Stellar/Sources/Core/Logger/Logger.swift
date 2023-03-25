// Log.swift

import Foundation

// MARK: - Log

/// The logger class used to print messages.
/// A default log instance is available via `Log.main` static variable.
public final class Logger: Equatable {
    
    // MARK: - Public Properties
    
    /// Unique log identifier.
    public let uuid = UUID()
    
    /// Subsystem identifier, typically the bundle identifier.
    public let subsystem: String
    
    /// Used to further distinguish a logger inside the same `subsystem`.
    public let category: String
    
    /// Complete log identifier (combination of `subsystem` and `category`).
    public lazy var label: String = {
        [subsystem, category].joined(separator: ".")
    }()

    /// Enable or disable log dispatch.
    public var isEnabled: Bool
    
    /// Current logging level.
    public private(set) var level: Level = .debug
    
    /// Extra dictionary array to complete log events.
    public var extra = Event.Metadata()
    
    // MARK: - Channels Access
    
    public subscript(level: Level) -> Channel? { channels[level.rawValue] }
    public var debug: Channel? { channels[Level.debug.rawValue] }
    public var info: Channel? { channels[Level.info.rawValue] }
    public var warning: Channel? { channels[Level.warning.rawValue] }
    public var error: Channel? { channels[Level.error.rawValue] }
    
    // MARK: - Private Properties

    private let queue: DispatchQueue
    private var channels: [Channel?] = .init(repeating: nil, count: Level.allCases.count)
    let transporter: Transporter

    // MARK: - Initialization
    
    /// Initialize a new log instance with given configuration builder callback.
    ///
    /// - Parameter builder: callback.
    public convenience init(_ builder: ((inout Config) -> Void)) {
        let config = Config(builder)
        self.init(config: config)
    }
    
    /// Initialize a new log instance with given configuration.
    ///
    /// - Parameter config: configuration.
    public init(config: Config) {
        self.queue = DispatchQueue(label: "com.log.channels.\(uuid.uuidString)")
        self.isEnabled = config.isEnabled
        self.subsystem = config.subsystem
        self.category = config.category
        self.transporter = Transporter(config: config)

        setLevel(config.level)
    }
    
    public static func == (lhs: Logger, rhs: Logger) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    // MARK: - Private Methods
    
    /// Update active channel instances based upon the current set level.
    ///
    /// - Parameter level: level to set.
    private func setLevel(_ level: Level) {
        queue.sync {
            self.level = level
            Level.allCases.forEach { cLevel in
                channels[cLevel.rawValue] = (cLevel > level ? nil :  Channel(log: self, level: cLevel))
            }
        }
    }
    
}

// MARK: - Shared Log

extension Logger {
    
    /// Shared general log instance.
    static let shared = Logger {
        $0.level = (isRunningInDebug() ? .debug : .info)
        $0.subsystem = "com.stellar"
        $0.category = "general"
        $0.transports = [
            ConsoleLogTransport()
        ]
    }
    
    /// Severity level of the shared logger.
    static var level: Level {
        get { Logger.shared.level }
        set { Logger.shared.level = newValue }
    }
    
    /// Set the verbose logging adapting the level of severity.
    static var verbose: Bool {
        get { Logger.shared.level == .debug }
        set { Logger.shared.level = (newValue ? .debug : .info) }
    }
    
    // MARK: - Shortcuts for shared logger
    
    public static var debug: Channel? { Logger.shared.channels[Level.debug.rawValue] }
    public static var info: Channel? { Logger.shared.channels[Level.info.rawValue] }
    public static var warning: Channel? { Logger.shared.channels[Level.warning.rawValue] }
    public static var error: Channel? { Logger.shared.channels[Level.error.rawValue] }
    
}
