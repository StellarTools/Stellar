import Foundation

// MARK: - String

extension String {
    
    /// Return the last path component of the string.
    public var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }
    
    /// Remove trailing newline characters (`\n` in UNIX or `\r\n` in Windows.
    /// It will not remove mixed occurrences of both separators.
    ///
    /// - Parameter separator: separator of the lines. if not specific default UNIX/Windows chars are used.
    /// - Returns: clean string.
    public func cleanShellOutput(separator: String? = nil) -> String {
        func scrub(_ separator: String) -> String {
            var E = endIndex
            while String(self[startIndex..<E]).hasSuffix(separator) && E > startIndex {
                E = index(before: E)
            }
            return String(self[startIndex..<E])
        }

        if let separator = separator {
            return scrub(separator)
        } else if hasSuffix("\r\n") {
            return scrub("\r\n")
        } else if hasSuffix("\n") {
            return scrub("\n")
        } else {
            return self
        }
    }
    
}

// MARK: - URL

extension URL {
    
    /// Shortcut to create a glob patter to the specified url directory.
    ///
    /// - Parameter pattern: pattern to construct the glob.
    /// - Returns: contents at the path with the pattern set.
    func glob(_ pattern: String) -> [String] {
        Glob(pattern: appendingPathComponent(pattern).path).paths
    }
    
}

// MARK: - HTTPURLResponse & URLResponse

extension URLResponse {
    
    /// The HTTP status code received from a network response.
    /// If not parsable, `0` is returned.
    var httpStatusCode: Int {
        (self as? HTTPURLResponse)?.statusCode ?? 0
    }
    
}

extension HTTPURLResponse {
    
    /// Return `true` if response is not an error.
    ///
    /// - Returns: boolean
    func isResponseOK() -> Bool {
        (200...299).contains(self.statusCode)
    }
    
}
