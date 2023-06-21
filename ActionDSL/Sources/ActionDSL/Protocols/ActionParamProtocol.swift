//  ActionParamProtocol.swift

import Foundation

public protocol ActionParamProtocol {
    var environment: String? { get }
    var wrappedValue: String? { get set }
    var propertyName: String? { get set }
    var defaultValue: String? { get }
    var isRequired: Bool { get }
}
