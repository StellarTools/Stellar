//  FileManaging.swift

import Foundation

protocol FileManaging {
    var currentLocation: URL { get }
    var executableLocation: URL { get }
}
