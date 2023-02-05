import Foundation

// MARK: - String

extension String {
    
    public var lastPathComponent: String {
        (self as NSString).lastPathComponent
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
    
    public var httpResponse: HTTPURLResponse? {
        self as? HTTPURLResponse
    }
    
    var httpStatusCode: Int {
        httpResponse?.statusCode ?? 0
    }
    
}

extension HTTPURLResponse {
    
    func isResponseOK() -> Bool {
        (200...299).contains(self.statusCode)
    }
    
}
