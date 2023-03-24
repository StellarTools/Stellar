// Log.swift

import Foundation

/// The logger class used to print messages.
/// A default log instance is available via `Log.main` static variable.
public final class Log: Equatable {
    
    // MARK: - Public Log Properties
    
    /// Shared general log instance.
    public static let main = Log {
        $0.level = (isRunningInDebug() ? .debug : .info)
        $0.subsystem = "com.stellar"
        $0.category = "general"
    }
    
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
    
    public static func == (lhs: Log, rhs: Log) -> Bool {
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
