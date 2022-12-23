//  TestConfig.swift

import Foundation

struct TestConfig: Decodable {
    let scheme: String
    let platform: Platform
    let osVersion: String?
    let simulatorName: String?
    let path: String?
    
    enum CodingKeys: CodingKey {
        case scheme
        case platform
        case osVersion
        case simulatorName
        case path
    }
    
    enum RootCodingKeys: CodingKey {
        case test
    }
    
    enum TestConfigError: Error {
        case unrecognizedPlatform
    }
    
    init(from decoder: Decoder) throws {
        let container1 = try decoder.container(keyedBy: RootCodingKeys.self)
        let container = try container1.nestedContainer(keyedBy: CodingKeys.self, forKey: RootCodingKeys.test)
        self.scheme = try container.decode(String.self, forKey: .scheme)
        let platformValue = try container.decode(String.self, forKey: .platform)
        guard let platform = Platform(rawValue: platformValue) else {
            throw TestConfigError.unrecognizedPlatform
        }
        self.platform = platform
        self.osVersion = try container.decodeIfPresent(String.self, forKey: .osVersion)
        self.simulatorName = try container.decodeIfPresent(String.self, forKey: .simulatorName)
        self.path = try container.decodeIfPresent(String.self, forKey: .path)
    }
}
