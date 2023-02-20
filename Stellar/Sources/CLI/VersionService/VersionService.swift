//  VersionService.swift

import Foundation
import StellarCore

final class VersionService {
    func run() throws {
        Logger().log("\(Constants.version)")
    }
}
