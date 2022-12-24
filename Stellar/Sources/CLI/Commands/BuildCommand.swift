//  BuildCommand.swift

import ArgumentParser
import Foundation
import ShellOut
import Stellar

struct BuildCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Abstract")
    
    @Option(name: .shortAndLong, help: "")
    private var path: String
    
    @Option(name: .shortAndLong, help: "")
    private var output: String
    
    @Flag(name: .shortAndLong, help: "")
    private var verbose: Bool = false
    
    func run() throws {
        let urlPath = URL(string: path)!
            .appendingPathComponent(Constants.stellarFolder, isDirectory: true)
            .appendingPathComponent(Constants.executorFolder, isDirectory: true)
        
        try shellOut(to: "swift",
                     arguments:
                        [
                            "build",
                            "-c release",
//                            "--arch arm64",
//                            "--arch x86_64"
                        ],
                     at: urlPath.path,
                     outputHandle: .standardOutput,
                     errorHandle: .standardError)
        
        let binaryPath = try shellOut(to: "swift",
                                      arguments:
                                        [
                                            "build",
                                            "-c release",
                                            "--show-bin-path"
                                        ],
                                      at: urlPath.path,
                                      errorHandle: .standardError)
        let binaryUrl = URL(string: binaryPath)!
            .appendingPathComponent(Constants.executor, isDirectory: false)
        
        let outputUrl = URL(string: output)!
            .appendingPathComponent(Constants.stellarFolder, isDirectory: true)
            .appendingPathComponent(Constants.executablesFolder, isDirectory: true)
        
        var objcTrue: ObjCBool = true
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: outputUrl.path, isDirectory: &objcTrue) {
            try fileManager.createDirectory(atPath: outputUrl.path, withIntermediateDirectories: true)
        }
        
        try shellOut(to: "mv",
                     arguments:
                        [
                            binaryUrl.path,
                            outputUrl.path
                        ],
                     outputHandle: .standardOutput,
                     errorHandle: .standardError)
    }
}

