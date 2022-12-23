//  DestinationFactory.swift

import Foundation

extension String: Error {}

public class DestinationFactory {
    
    static public func makeDestination(from platform: Platform, osVersion: String?, simulatorName: String?) throws -> String {
        switch platform {
        case .iOS:
            guard let osVersion else {
                throw "Missing OSVersion parameter."
            }
            guard let simulatorName else {
                throw "Missing simulatorName parameter."
            }
            return "'platform=iOS Simulator,OS=\(osVersion),name=\(simulatorName)'"
        case .macOS:
            return "'platform=macOS,arch=arm64'"
        }
    }
}
