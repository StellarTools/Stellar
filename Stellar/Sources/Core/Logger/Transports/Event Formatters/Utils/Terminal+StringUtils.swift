// Terminal+StringUtils.swift

import Foundation

extension String {
    
    func pad(_ style: StringPadding?, filler: Character = " ") -> String {
        guard let style else { return self }
        return style.pad(text: self, length: style.length, filler: filler)
    }
    
}

extension String.StringInterpolation {
    
    mutating func apply(pad: StringPadding?, to value: Any) {
        guard let pad else {
            return appendInterpolation("\(value)")
        }
        
        appendLiteral(String(describing: value).pad(pad))
    }
    
}

// MARK: - StringPadding

public enum StringPadding {
    case left(_ columns: Int)
    case right(_ columns: Int)
    case center(_ columns: Int)
    
    fileprivate func pad(text: String, length: Int, filler: Character = " ") -> String {
        let padding: String = {
            let byteLength = text.lengthOfBytes(using: String.Encoding.utf32) / 4
            guard length > byteLength else {
                return ""
            }

            let paddingLength = length - byteLength
            return String(repeating: String(filler), count: paddingLength)
        }()

        switch self {
        case .left:
            return text + padding
        case .right:
            return padding + text
        case .center:
            let halfDistance = padding.distance(from: padding.startIndex, to: padding.endIndex) / 2
            let halfIndex = padding.index(padding.startIndex, offsetBy: halfDistance)
            let leftHalf = padding[..<halfIndex]
            let rightHalf = padding[halfIndex...]
            return leftHalf + text + rightHalf
        }
    }
    
    fileprivate var length: Int {
        switch self {
        case let .left(l):      return l
        case let .center(l):    return l
        case let .right(l):     return l
        }
    }
    
}

