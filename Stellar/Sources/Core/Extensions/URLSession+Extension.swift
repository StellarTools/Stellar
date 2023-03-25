//  URLSession+Extension.swift

import Foundation

extension URLSession {
    
    /// Perform a call to GitHub APIs service.
    ///
    /// - Parameters:
    ///   - url: url to the api.
    ///   - model: model to decode.
    /// - Returns: decoded object or exception if something fails.
    public func gitHubAPI<T:Codable>(url: URL, decode model: T.Type) throws -> T? {
        var urlRequest = URLRequest(url: url, timeoutInterval: 5)
        urlRequest.attachGitHubHeaders(forBinary: false)
        return try fetch(request: urlRequest, decode: model)
    }
    
    /// Perform a network request and decode the result with Codable conform object.
    ///
    /// - Parameters:
    ///   - request: request to execute.
    ///   - model: decoded object.
    /// - Returns: decoded model or exception if something fails.
    public func fetch<T:Codable>(request: URLRequest, decode model: T.Type) throws -> T? {
        Logger.debug?.write("  [\(request.httpMethod ?? "GET")] \(request.url?.absoluteString ?? "")")
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?, error: Error?

        dataTask(with: request) {
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
    
    /// Buffer size for file download.
    private static let bufferSize = 65_536
    
    /// Download a file synchrously from a given URL and move to the specified directory if necessary.
    ///
    /// - Parameters:
    ///   - URL: URL of the file to download.
    ///   - destinationURL: destination URL of the file into the local filesystem.
    ///                     If not specified file will stay in place.
    /// - Returns: URL of the file.
    @discardableResult
    public func downloadFile(atURL url: URL, saveAtURL: URL? = nil) throws -> URL {
        let fileURL = saveAtURL ?? URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)

        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
            urlRequest.attachGitHubHeaders(forBinary: true)
            _  = try await download(request: urlRequest, delegate: Redirect.shared, fileURL: fileURL)
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        return fileURL
    }
    
    /// Download asynchronously a file without loading the entire data in memory
    /// and save it to specified destination.
    ///
    /// - Parameters:
    ///   - request: request to file.
    ///   - delegate: optional delegate for session data task.
    ///   - fileURL: destination local file.
    /// - Returns: http response
    public func download(request: URLRequest,
                         delegate: URLSessionTaskDelegate? = nil,
                         fileURL: URL) async throws -> URLResponse {
        
        let (bytes, httpResponse) = try await bytes(for: request, delegate: delegate)
        let expectedFileLength = httpResponse.expectedContentLength
        
        guard let fileStream = OutputStream(url: fileURL, append: false) else {
            throw URLError(.cannotOpenFile)
        }
        
        fileStream.open()
        var bufferedData = Data()
        bufferedData.reserveCapacity(min(URLSession.bufferSize, Int(expectedFileLength)))
        
        // get the data and write it by using the internal buffer to avoid loading the memory.
        var bytesCount = Int64(0)
        for try await byte in bytes {
            try Task.checkCancellation()
            
            bytesCount += 1
            bufferedData.append(byte)
            
            if bufferedData.count > URLSession.bufferSize {
                try fileStream.write(data: bufferedData)
                bufferedData.removeAll(keepingCapacity: true)
            }
        }
        
        // some data left on buffer, we'll write it before closing the stream
        if !bufferedData.isEmpty {
            try fileStream.write(data: bufferedData)
        }
        
        fileStream.close()
        
        return httpResponse
    }
    
}

// MARK: - OutputStream

extension OutputStream {
    
    /// Errors writing data.
    public enum Errors: Error {
        case bufferFailure
        case writeFailure
    }
    
    /// Write data into the stream.
    ///
    /// - Parameter data: data to write.
    fileprivate func write(data: Data) throws {
        try data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) throws in
            guard var pointer = buffer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw Errors.bufferFailure
            }
            
            var bytesRemaining = buffer.count
            while bytesRemaining > 0 {
                let bytesWritten = write(pointer, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    throw Errors.writeFailure
                }
                
                bytesRemaining -= bytesWritten
                pointer += bytesWritten
            }
        }
    }
}

extension URLRequest {
    
    mutating func attachGitHubHeaders(forBinary: Bool) {
        setValue("Bearer \(GitHubAPI.gitHubToken)", forHTTPHeaderField: "Authorization")
        setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        if forBinary {
            setValue("application/octet-stream", forHTTPHeaderField: "Accept")
        } else {
            setValue("application/json", forHTTPHeaderField: "Accept")
        }
    }
    
}

private class Redirect: NSObject, URLSessionTaskDelegate, URLSessionDelegate {
    
    public static let shared = Redirect()
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
    
}
