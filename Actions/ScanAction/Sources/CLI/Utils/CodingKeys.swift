//  CodingKeys.swift

import Foundation

enum CodingKeys: CodingKey {
    case custom(String)
 
    init?(stringValue: String) {
        self = .custom(stringValue)
    }
    
    var stringValue: String {
        switch self {
        case let .custom(name): return name
        }
    }
    
    // Just to silence the compiler, never used.
    var intValue: Int? { nil }
    init?(intValue _: Int) { nil }
}
