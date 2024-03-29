//  MockFileManager.swift

import Foundation
@testable import StellarCLI

class MockFileManager: FileManaging {
    
    var currentLocation: URL {
        URL(fileURLWithPath: "/Users/john.doe/Projects/MyProject")
    }
    
    var executableLocation: URL {
        URL(fileURLWithPath: "/usr/local/bin/")
    }
}
