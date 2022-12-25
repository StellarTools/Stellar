//  StellarError.swift

import Foundation

enum StellarError: Error {
    case missingStellarFolder(URL)
    case missingExecutorFolder(URL)
    case missingExecutorPackage(URL)
    case missingExecutorSourcesFolder(URL)
    case missingExecutablesFolder(URL)
}
