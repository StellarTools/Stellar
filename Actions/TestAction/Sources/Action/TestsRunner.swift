//  TestsRunner.swift

import Foundation

public struct TestsRunner {
    
    @discardableResult
    static public func runTests(scheme: String,
                                platform: Platform,
                                osVersion: String?,
                                simulatorName: String?,
                                path: String) throws -> String {
        return try CommandExecutor.executeXcodebuild(
            command: "test",
            arguments: [
                "-scheme",
                scheme,
                "-destination",
                try DestinationFactory.makeDestination(from: platform,
                                                       osVersion: osVersion,
                                                       simulatorName: simulatorName)
            ],
            at: path
        )
    }
}
