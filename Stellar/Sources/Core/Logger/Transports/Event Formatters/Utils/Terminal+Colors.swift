// Terminal+Colors.swift

import Foundation

// MARK: - TerminalColors

public enum TerminalColor: RawRepresentable {
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case extd(UInt8)
    
    public init?(rawValue: UInt8) {
        switch rawValue {
            case 0:     self = .black
            case 1:     self = .red
            case 2:     self = .green
            case 3:     self = .yellow
            case 4:     self = .blue
            case 5:     self = .magenta
            case 6:     self = .cyan
            case 7:     self = .white
            default:    self = .extd(rawValue)
        }
    }
    
    public var rawValue: UInt8 {
        switch self {
            case .black:        return 0
            case .red:          return 1
            case .green:        return 2
            case .yellow:       return 3
            case .blue:         return 4
            case .magenta:      return 5
            case .cyan:         return 6
            case .white:        return 7
            case .extd(let n):  return n
        }
    }
    
}

// MARK: - TerminalStyle

public struct TerminalStyle: OptionSet {
    public static let bold = TerminalStyle(rawValue: 1 << 0)
    public static let italic = TerminalStyle(rawValue: 1 << 2)
    public static let underlined = TerminalStyle(rawValue: 1 << 3)
    public static let strikethrough = TerminalStyle(rawValue: 1 << 7)

    public static let dim = TerminalStyle(rawValue: 1 << 1)
    public static let blink = TerminalStyle(rawValue: 1 << 4)
    public static let inverse = TerminalStyle(rawValue: 1 << 5)
    public static let hidden = TerminalStyle(rawValue: 1 << 6)
    
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Interpolation Support

extension String.StringInterpolation {
    
    // MARK: - Private Properties
    
    private static let openSequence = "\u{001B}["
    private static let closeSequence = "m"
    private static let resetSequence = "\u{001B}[0m"
    private static let lookups: [(TerminalStyle, Int)] = [
        (.bold, 1),
        (.dim, 2),
        (.italic, 3),
        (.underlined, 4),
        (.blink, 5),
        (.inverse, 7),
        (.hidden, 8),
        (.strikethrough, 9)
    ]

    // MARK: - Public Methods
    
    mutating public func appendInterpolation(_ any: Any, color: TerminalColor) {
        applyTerminal(color: color, back: nil, style: nil, to: any)
    }
    
    mutating public func appendInterpolation(_ any: Any, back: TerminalColor) {
        applyTerminal(color: nil, back: back, style: nil, to: any)
    }
    
    mutating public func appendInterpolation(_ any: Any, style: TerminalStyle) {
        applyTerminal(color: nil, back: nil, style: style, to: any)
    }
    
    mutating public func appendInterpolation(_ any: Any, color: TerminalColor, back: TerminalColor) {
        applyTerminal(color: color, back: back, style: nil, to: any)
    }
    
    mutating public func appendInterpolation(_ any: Any, back: TerminalColor, style: TerminalStyle) {
        applyTerminal(color: nil, back: back, style: style, to: any)
    }
    
    mutating public func appendInterpolation(_ any: Any, color: TerminalColor, style: TerminalStyle) {
        applyTerminal(color: color, back: nil, style: style, to: any)
    }
    
    mutating public func appendInterpolation(_ any: Any, color: TerminalColor, back: TerminalColor, style: TerminalStyle) {
        applyTerminal(color: color, back: back, style: style, to: any)
    }
    
    
    // MARK: - Private Methods
    
    private mutating func applyTerminal(color: TerminalColor?,
                                        back: TerminalColor?,
                                        style: TerminalStyle?,
                                        to value: Any) {
        
        guard stdOutSupportColors else {
            // If colors are not supported fallback to plain string transparently.
            return appendInterpolation("\(value)")
        }
        
        appendLiteral(String.StringInterpolation.openSequence)
        
        var outputCode: [String] = []
        
        if let color {
            outputCode.append("38")
            outputCode.append("5")
            outputCode.append("\(color.rawValue)")
        }
        
        if let back {
            outputCode.append("48")
            outputCode.append("5")
            outputCode.append("\(back.rawValue)")
        }
        
        if let style {
            for (key, value) in String.StringInterpolation.lookups where style.contains(key) {
                outputCode.append(String(value))
            }
        }

        appendInterpolation(outputCode.joined(separator: ";"))
        appendLiteral(String.StringInterpolation.closeSequence)
        appendInterpolation("\(value)")
        
        // reset style when closing sequence
        appendLiteral(String.StringInterpolation.resetSequence)
    }
}

// MARK: - Helper Functions

let stdOutSupportColors: Bool = {
    if let cliColorForce = ProcessInfo.processInfo.environment["CLICOLOR_FORCE"],
       ["1", "yes", "true"].contains(cliColorForce) {
        return true
    }
    
    guard isatty(STDOUT_FILENO) == 1 else {
        return false
    }
    
    if let xpcServiceName = ProcessInfo.processInfo.environment["XPC_SERVICE_NAME"],
       xpcServiceName.localizedCaseInsensitiveContains("com.apple.dt.xcode") {
        return false
    }
    
    guard let term = ProcessInfo.processInfo.environment["TERM"],
          !["", "dumb", "cons25", "emacs"].contains(term) else {
        return false
    }
    
    return true
}()
