import Foundation

public final class NetworkManager {
    
    private var session = URLSession.shared
    private let fileManager: FileManaging
    
    public init(fileManager: FileManaging = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func httpRequest<T:Codable>(model: T.Type, url: URL) throws -> T? {
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
    public func getFile(atURL URL: URL, saveAtURL destinationURL: URL?) throws -> URL {
        let outputURL = destinationURL ?? fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        let semaphore = DispatchSemaphore(value: 0)
        let request = URLRequest(url: URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        var tempFileURL: URL?
        var urlResponse: URLResponse?
        var error: Error?

        session.downloadTask(with: request) {
            tempFileURL = $0
            urlResponse = $1
            error = $2
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        guard let httpResponse = urlResponse?.httpResponse,
              httpResponse.isResponseOK() else {
            throw StellarError(.internal, reason: "Server responded with HTTP \(urlResponse?.httpStatusCode ?? 0): \(error?.localizedDescription ?? "")")
        }
        
        if let tempFileURL {
            try fileManager.copyFile(from: tempFileURL, to: outputURL)
        }
        
        return outputURL
    }
    
    private func urlRequestForFileDownload(url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
