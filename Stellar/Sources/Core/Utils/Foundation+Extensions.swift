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

// MARK: - URLSession

extension URLSession {
    
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
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        Task {
            _  = try await download(request: urlRequest, fileURL: fileURL)
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

