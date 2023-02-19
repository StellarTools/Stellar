import Foundation

/// Network provider suitable for JSON api request, like the ones for GitHub.
public final class APIProvider {
    
    // MARK: - Public Properties
    
    private var session = URLSession.shared
    private let fileManager: FileManaging = FileManager.default
    
    // MARK: - Initialization
    
    public init() { }
    
    /// Perform a json request and decode the result.
    ///
    /// - Parameters:
    ///   - url: url of the request.
    ///   - decode: model used to decode the result.
    /// - Returns: requested model, if any.
    public func fetch<T:Codable>(url: URL, decode model: T.Type) throws -> T? {
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?, error: Error?

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: urlRequest) {
            data = $0
            error = $2
            semaphore.signal()
        }.resume()

        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error {
            throw error
        }
        
        guard let data else {
            return nil
        }
        
        return try JSONDecoder().decode(model.self, from: data)
    }
    
    // MARK: - Private Properties
    
    /// Return the `URLRequest` object to perform HTTP JSON request.
    ///
    /// - Parameter url: url.
    /// - Returns: the request to execute
    private func urlRequestForFileDownload(url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
