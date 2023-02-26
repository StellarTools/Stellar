import Foundation
import StellarCore

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
        
        public enum MockResponse {
            public typealias ResponseCallback = ((URLRequest) throws -> (HTTPURLResponse, Data))

            case fileData(URL)
            case customCallback(ResponseCallback)
            
            static func toFileData(_ fileURL: URL) -> MockResponse {
                return .fileData(fileURL)
            }
            
            static func toEvaluation(_ callback: @escaping ResponseCallback) -> MockResponse {
                .customCallback(callback)
            }
            
        }
        
        /// Match the URL using a regular expression
        case matchURLRegExp(String, MockResponse)
        /// Check if URL is equalt to passed
        case matchURLString(String, MockResponse)
        
        // MARK: - Initialixation
        
        static func regExp(_ pattern: String, response: MockResponse) -> Mock {
            .matchURLRegExp(pattern, response)
        }
        
        static func urlEqualTo(_ url: String, response: MockResponse) -> Mock {
            .matchURLString(url, response)
        }
        
        // MARK: - Private Functions
        
        var response: MockResponse {
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
        
        let urlString = request.url?.absoluteString ?? ""
        Logger().log("[\(hasMocked ? "MOCK" : "NETWORK")] <- \(urlString)")
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
            let response: HTTPURLResponse
            let responseData: Data
            
            switch mock.response {
            case .fileData(let stubFileURL):
                responseData = try Data(contentsOf: stubFileURL)
                response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            case .customCallback(let callback):
                (response, responseData) = try callback(request)
            }

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: responseData)
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
