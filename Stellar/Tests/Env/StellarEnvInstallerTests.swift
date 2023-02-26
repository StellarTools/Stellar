import XCTest
@testable import StellarEnv
@testable import StellarCore

final class StellarEnvInstallerTests: XCTestCase {
    
    private let urlSession = HTTPMockServer.shared.urlSession
    
    public func test_envInstall() throws {
        let expectation = expectation(description: "Open a file asynchronously.")
        
        HTTPMockServer.shared.addMock(.matchURLString("http://www.apple.com", { request in
            let exampleData = "merda".data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }))
        
        /*let urlRequest = URLRequest(url: URL(string: "http://www.apple.com")!)
        urlSession.dataTask(with: urlRequest) { data, response, error in
           // ... handle your response
            print(String(data: data!, encoding: .utf8))
            expectation.fulfill()
            
        }.resume()*/
        
        let update = try EnvInstaller().install()
        
        wait(for: [expectation], timeout: 100.0)

    }
    
}
