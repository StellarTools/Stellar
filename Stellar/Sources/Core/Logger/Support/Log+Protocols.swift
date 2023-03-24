// Log+Protocols.swift

import Foundation

// MARK: - Transport

/// A transport is where events are received and stored.
/// A `Log` instance can have one or more underlying transport services.
public protocol Transport {
    
    /// GCD queue that will be used when executing tasks related to the receiver.
    var queue: DispatchQueue { get }
    
    /// Enable or disable the transport.
    var isEnabled: Bool { get set }
    
    /// Used to exclude a transport for events of a certain severity.
    var minimumAcceptedLevel: Log.Level? { get set }
    
    /// Record a new event into the transport.
    ///
    /// - Parameter event: event to store.
    /// - Returns: `true` if event is stored, `false` otherwise.
    @discardableResult func record(event: Log.Event) -> Bool
    
}

// MARK: - TransportFilter


/// Filters are used to early discard message events from being received by a log instance.
public protocol TransportFilter {
    
    /// Determine if an event should be handled by the log transports.
    ///
    /// - Parameter event: event to check.
    /// - Returns: `true` to accept the event, `false` to discard it.
    func shouldAccept(_ event: Log.Event) -> Bool
    
}

