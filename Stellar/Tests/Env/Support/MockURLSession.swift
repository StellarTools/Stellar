import Foundation

public class HTTPMockServer {
    
    // MARK: - Public Properties
    
    public static let shared = HTTPMockServer()
    public let urlSession: URLSession
    public private(set) var mocks = [Mock]()
      
    // MARK: - Private Properties
    
    private let queue = DispatchQueue(label: "httpmockserver.queue.concurrent", attributes: .concurrent)

    // MARK: - Initialixation
    
    private init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        self.urlSession = URLSession(configuration: configuration)
    }
    
    // MARK: - Public Function
        
    /// Add a new mock to the queue.
    ///
    /// - Parameter mock: mock.
    /// - Returns: return Self
    @discardableResult
    public func addMock(_ mock: Mock) -> Self {
        mocks.append(mock)
        return self
    }
    
    /// Remove all mocked stubs.
    public func resetMocks() {
        mocks.removeAll()
    }
    
    // MARK: - Internal Functions
    
    /// Return `true` when a mock match a passed request.
    ///
    /// - Parameter request: request to validate.
    /// - Returns: mock, if any,
    func matchedMockForRequest(_ request: URLRequest) -> Mock? {
        queue.sync {
            self.mocks.first {
                $0.satisfyRequest(request)
            }
        }
    }
    
}

extension HTTPMockServer {
    
    public enum Mock {
        public typealias Response = ((URLRequest) throws -> (HTTPURLResponse, Data))
        
        /// Match the URL using a regular expression
        case matchURLRegExp(String, Response)
        /// Check if URL is equalt to passed
        case matchURLString(String, Response)
        
        // MARK: - Initialixation
        
        static func regExp(_ pattern: String, response: @escaping Response) -> Mock {
            .matchURLRegExp(pattern, response)
        }
        
        static func urlEqualTo(_ url: String, response: @escaping Response) -> Mock {
            .matchURLString(url, response)
        }
        
        // MARK: - Private Functions
        
        var response: Response {
            switch self {
            case .matchURLRegExp(_, let response): return response
            case .matchURLString(_, let response): return response
            }
        }
        
        /// Return `true` if mock validates a request.
        ///
        /// - Parameter request: request to validate.
        /// - Returns: `true` if mock validate the request, `false` otherwise.
        func satisfyRequest(_ request: URLRequest) -> Bool {
            guard let requestURLString = request.url?.absoluteString else { return false }

            switch self {
            case .matchURLRegExp(let pattern, _):
                do {
                    let regex = try Regex(pattern)
                    return try regex.firstMatch(in: requestURLString) != nil
                } catch {
                    return false
                }
            case .matchURLString(let targetURL, _):
                return targetURL == requestURLString
            }
        }
        
    }
    
}

public class MockURLProtocol: URLProtocol {
            
    override class public func canInit(with request: URLRequest) -> Bool {
        // Returning false we'll use any other `URLProtocol`, so basically perform an actual network call.
        let mockRequest = HTTPMockServer.shared.matchedMockForRequest(request)
        let hasMocked = mockRequest != nil
        print("\(request.url?.absoluteString ?? "") has mock? \(hasMocked ? "YES": "NO")")
        return hasMocked
    }
    
    override class public func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override public func stopLoading() {
        
    }
    
    override public func startLoading() {
        guard let mock = HTTPMockServer.shared.matchedMockForRequest(request) else {
            client?.urlProtocol(self, didFailWithError: MockErrors.unhandledRequest(request))
            return // it should never happens since we'll redirect to the actual network connection
        }
        
        do {
            // Respond with mock.
            let (response, data) = try mock.response(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch  {
            client?.urlProtocol(self, didFailWithError: MockErrors.failedToPrepareMockResponse(request, error))
        }
    }
    
}

public enum MockErrors: Error {
    case unhandledRequest(URLRequest)
    case failedToPrepareMockResponse(URLRequest, Error)
}
