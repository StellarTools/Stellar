import Foundation

public final class NetworkManager {
    
    private var session = URLSession.shared
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func jsonRequest<T:Codable>(model: T.Type, url: URL) throws -> T? {
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
    
    @discardableResult
    public func downloadFile(atURL URL: URL, saveAtURL destinationURL: URL? = nil) async throws -> URL {
        let outputURL = destinationURL ?? fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        let urlRequest = urlRequestForFileDownload(url: URL)
        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response.httpResponse,
              httpResponse.isResponseOK() else {
            throw StellarError(.internal, reason: "Server responded with HTTP \(response.httpStatusCode)")
        }
        
        try data.write(to: outputURL, options: .noFileProtection)
        return outputURL
    }
    
    private func urlRequestForFileDownload(url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        request.setValue("application/octet-stream", forHTTPHeaderField: "Accept")
        return request
    }
    
}
