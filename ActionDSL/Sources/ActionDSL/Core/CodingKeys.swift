//  CodingKeys.swift

import Foundation

public enum CodingKeys: CodingKey {
    case custom(String)

    public init?(stringValue: String) {
        self = .custom(stringValue)
    }

    public var stringValue: String {
        switch self {
        case let .custom(name): return name
        }
    }

    // Just to silence the compiler, never used.
    public var intValue: Int? { nil }
    public init?(intValue _: Int) { nil }
}
