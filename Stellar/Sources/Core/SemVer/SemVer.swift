//  SemVer.swift

import Foundation

/// Represents a version conforming to [Semantic Versioning 2.0.0](http://semver.org).
public struct SemVer {
    
    /// The major version.
    public let major: Int
    
    /// The minor version.
    public let minor: Int
    
    /// The patch version.
    public let patch: Int
    
    /// The pre-release identifiers (if any).
    public let prerelease: [String]
    
    /// The build metadatas (if any).
    public let buildMetadata: [String]
    
    /// Creates a version with the provided values.
    ///
    /// The result is unchecked. Use `isValid` to validate the version.
    public init(major: Int, minor: Int, patch: Int, prerelease: [String] = [], buildMetadata: [String] = []) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease
        self.buildMetadata = buildMetadata
    }
    
    /// A string representation of prerelease identifiers (if any).
    public var prereleaseString: String? {
        return prerelease.isEmpty ? nil : prerelease.joined(separator: ".")
    }
    
    /// A string representation of build metadatas (if any).
    public var buildMetadataString: String? {
        return buildMetadata.isEmpty ? nil : buildMetadata.joined(separator: ".")
    }
    
    /// A Boolean value indicating whether the version is pre-release version.
    public var isPrerelease: Bool {
        return !prerelease.isEmpty
    }
    
    /// A Boolean value indicating whether the version conforms to Semantic
    /// Versioning 2.0.0.
    ///
    /// An invalid Semver can only be formed with the memberwise initializer
    /// `Semver.init(major:minor:patch:prerelease:buildMetadata:)`.
    public var isValid: Bool {
        return major >= 0
            && minor >= 0
            && patch >= 0
            && prerelease.allSatisfy(validatePrereleaseIdentifier)
            && buildMetadata.allSatisfy(validateBuildMetadataIdentifier)
    }
}

extension SemVer: Equatable {
    
    /// Semver semantic equality. Build metadata is ignored.
    public static func ==(lhs: SemVer, rhs: SemVer) -> Bool {
        return lhs.major == rhs.major &&
            lhs.minor == rhs.minor &&
            lhs.patch == rhs.patch &&
            lhs.prerelease == rhs.prerelease
    }
    
    /// Swift semantic equality.
    public static func ===(lhs: SemVer, rhs: SemVer) -> Bool {
        return (lhs == rhs) && (lhs.buildMetadata == rhs.buildMetadata)
    }
    
    /// Swift semantic unequality.
    public static func !==(lhs: SemVer, rhs: SemVer) -> Bool {
        return !(lhs === rhs)
    }
}

extension SemVer: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(prerelease)
    }
}
    
extension SemVer: Comparable {
    
    public static func <(lhs: SemVer, rhs: SemVer) -> Bool {
        guard lhs.major == rhs.major else {
            return lhs.major < rhs.major
        }
        guard lhs.minor == rhs.minor else {
            return lhs.minor < rhs.minor
        }
        guard lhs.patch == rhs.patch else {
            return lhs.patch < rhs.patch
        }
        guard lhs.isPrerelease else {
            return false // Non-prerelease lhs >= potentially prerelease rhs
        }
        guard rhs.isPrerelease else {
            return true // Prerelease lhs < non-prerelease rhs
        }
        return lhs.prerelease.lexicographicallyPrecedes(rhs.prerelease) { lpr, rpr in
            if lpr == rpr { return false }
            // FIXME: deal with big integers
            switch (UInt(lpr), UInt(rpr)) {
            case let (l?, r?):  return l < r
            case (nil, nil):    return lpr < rpr
            case (_?, nil):     return true
            case (nil, _?):     return false
            }
        }
    }
}

extension SemVer: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        guard let version = SemVer(str) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid semantic version")
        }
        self = version
    }
}

extension SemVer: LosslessStringConvertible {
    
    private static let semverRegexPattern = #"^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([\da-zA-Z\-]+(?:\.[\da-zA-Z\-]+)*))?$"#
    private static let semverRegex = try! NSRegularExpression(pattern: semverRegexPattern)
    
    public init?(_ description:String) {
        guard let match = SemVer.semverRegex.firstMatch(in: description) else {
            return nil
        }
        guard let major = Int(description[match.range(at: 1)]!),
            let minor = Int(description[match.range(at: 2)]!),
            let patch = Int(description[match.range(at: 3)]!) else {
                // version number too large
                return nil
        }
        self.major = major
        self.minor = minor
        self.patch = patch
        prerelease = description[match.range(at: 4)]?.components(separatedBy: ".") ?? []
        buildMetadata = description[match.range(at: 5)]?.components(separatedBy: ".") ?? []
    }
    
    public var description: String {
        var result = "\(major).\(minor).\(patch)"
        if !prerelease.isEmpty {
            result += "-" + prerelease.joined(separator: ".")
        }
        if !buildMetadata.isEmpty {
            result += "+" + buildMetadata.joined(separator: ".")
        }
        return result
    }
}

extension SemVer: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        guard let v = SemVer(value.description) else {
            preconditionFailure("failed to initialize `Semver` using string literal '\(value)'.")
        }
        self = v
    }
}

// MARK: Foundation Extensions

extension Bundle {
    
    /// Use `CFBundleShortVersionString` key
    public var semanticVersion: SemVer? {
        return (infoDictionary?["CFBundleShortVersionString"] as? String).flatMap(SemVer.init(_:))
    }
}

extension ProcessInfo {
    
    public var operatingSystemSemanticVersion: SemVer {
        let v = operatingSystemVersion
        return SemVer(major: v.majorVersion, minor: v.minorVersion, patch: v.patchVersion)
    }
}

// MARK: - Utilities

private func validatePrereleaseIdentifier(_ str: String) -> Bool {
    guard validateBuildMetadataIdentifier(str) else {
        return false
    }
    let isNumeric = str.unicodeScalars.allSatisfy(CharacterSet.asciiDigits.contains)
    return !(isNumeric && (str.first == "0") && (str.count > 1))
}

private func validateBuildMetadataIdentifier(_ str: String) -> Bool {
    return !str.isEmpty && str.unicodeScalars.allSatisfy(CharacterSet.semverIdentifierAllowed.contains)
}

private extension CharacterSet {
    
    static let semverIdentifierAllowed: CharacterSet = {
        var set = CharacterSet(charactersIn: "0"..."9")
        set.insert(charactersIn: "a"..."z")
        set.insert(charactersIn: "A"..."Z")
        set.insert("-")
        return set
    }()
    
    static let asciiDigits = CharacterSet(charactersIn: "0"..."9")
}

private extension String {
    
    subscript(nsRange: NSRange) -> String? {
        guard let r = Range(nsRange, in: self) else {
            return nil
        }
        return String(self[r])
    }
}

private extension NSRegularExpression {
    
    func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        let r = NSRange(string.startIndex..<string.endIndex, in: string)
        return matches(in: string, options: options, range: r)
    }
    
    func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
        let r = NSRange(string.startIndex..<string.endIndex, in: string)
        return firstMatch(in: string, options: options, range: r)
    }
}
