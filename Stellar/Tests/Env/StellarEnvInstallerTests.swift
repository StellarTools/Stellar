import XCTest
@testable import StellarEnv
@testable import StellarCore

final class StellarEnvInstallerTests: XCTestCase {
    
    private let urlSession = HTTPMockServer.shared.urlSession
    
    public func test_envInstall() throws {
        let expectation = expectation(description: "Test Stellar Env Install.")
        
        guard let releasesFileURL = Bundle.module.url(forResource: "github_releases", withExtension: "json", subdirectory: "Tests"),
              let envPackageFileURL = Bundle.module.url(forResource: "StellarEnv", withExtension: "zip", subdirectory: "Tests") else {
            XCTFail("Failed to retrive stub resources")
            return
        }

        // Mock call for releases
        HTTPMockServer.shared.addMock(
            .matchURLString(
                "https://api.github.com/repos/StellarTools/Stellar/releases",
                .toFileData(releasesFileURL)
            )
        )
        
        HTTPMockServer.shared.addMock(
            .matchURLString(
                "https://github.com/StellarTools/Stellar/releases/download/0.0.3/StellarEnv.zip",
                .fileData(envPackageFileURL)
            )
        )
        
        let mockVersionProvider = VersionProvider(urlSession: urlSession)
        let envInstaller = EnvInstaller(versionProvider: mockVersionProvider)
        try envInstaller.install()
                
        wait(for: [expectation], timeout: 100.0)

    }
    
}
