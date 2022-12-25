//  StellarError.swift

import Foundation

public // shold be internal after things are moved from CLI to Core
enum StellarError: Error {
    case missingStellarFolder(URL)
    case missingExecutorFolder(URL)
    case missingExecutorPackage(URL)
    case missingExecutablesFolder(URL)
}
