//  VersionService.swift

import Foundation
import StellarCore

final class VersionService {
    func run() throws {
        Logger.info?.write(Constants.version)
    }
}
