// Log+Extensions.swift

import Foundation

// MARK: - Log.Event.Metadata Extension

extension Log.Event.Metadata {
    
    /// Merge the contents of two dictionaries.
    ///
    /// - Parameter otherMetadata: the dictionary merged into self.
    /// - Returns: merged dictionary where `otherMetadata` keys may replace self content.
    func merge(with otherMetadata: Log.Event.Metadata?) -> Log.Event.Metadata {
        guard let otherMetadata = otherMetadata else {
            return self
        }

        return merging(otherMetadata, uniquingKeysWith: { (_, new) in
            new
        })
    }
    
}

// MARK: - TransportFilter Extension

extension Array where Element == LogTransportFilter {
    
    /// Return `true` if event should be accepted by a log instance.
    ///
    /// - Parameter event: event to check.
    /// - Returns: `true` if accepted, `false` otherwise.
    func canAcceptEvent(_ event: Log.Event) -> Bool {
        guard isEmpty == false else { return true }
        if let _ = first(where: { $0.shouldAccept(event) == false }) {
            return false
        }
        
        return true
    }
    
}

// MARK: - Other

/// Is the app running in debug mode.
///
/// - Returns: `true` if running in debug mode, `false` otherwise.
func isRunningInDebug() -> Bool {
    #if DEBUG
    true
    #else
    false
    #endif
}
