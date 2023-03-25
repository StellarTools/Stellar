// ASCIITable+Support.swift

import Foundation

extension ASCIITable {
    
    // MARK: - Borders

    public typealias Borders = (top: Character?, bottom: Character?)
    
    // MARK: - Margins
    
    public struct Margins {
        
        // MARK: - Public Properties
        
        public let leading: String
        public let trailing: String
        
        public static let none = Margins(leading: "", trailing: "")
        
        var count: Int { leading.count + trailing.count }
        
    }
    
    // MARK: - TextAlign
    
    public typealias TextAlign = (h: TextHAlign, v: TextVAlign)

    public enum TextHAlign {
        case leading, center, trailing
        
        // MARK: - Internal Methods
        
        func apply(text: [Substring], width: Int, filler: Character) -> [String] {
            text.map { line -> String in
                let length = line.count
                guard length < width else { return String(line) }
                let pad = width - length
                switch self {
                case .leading:
                    return line + String(repeating: filler, count: pad)
                case .center:
                    let leftPad = Int(Double(pad) / 2.0)
                    let rightPad = leftPad * 2 < pad ? leftPad + 1 : leftPad
                    let left = String(repeating: filler, count: leftPad)
                    let right = String(repeating: filler, count: rightPad)
                    return "\(left)\(line)\(right)"
                case .trailing:
                    return String(repeating: filler, count: pad) + line
                }
            }
        }
    }
    
    public enum TextVAlign {
        case top, middle, bottom
        
        // MARK: - Internal Methods
        
        func apply(text: [Substring], height: Int) -> [Substring] {
            guard text.count < height else {
                return text
            }
            
            let emptySub = ""[...]
            let pad = height - text.count
            switch self {
            case .top:
                return text + [Substring](repeating: emptySub, count: pad)
            case .middle:
                let topPad = Int(Double(pad) / 2.0)
                let bottomPad = topPad * 2 < pad ? topPad + 1 : topPad
                return (
                    [Substring](repeating: emptySub, count: topPad) +
                        text +
                        [Substring](repeating: emptySub, count: bottomPad)
                )
            case .bottom:
                return [Substring](repeating: emptySub, count: pad) + text
            }
        }
        
    }
    
    // MARK: - Corners
    
    public struct Corners {
        
        // MARK: - Public Properties
        
        public var topLeading: Character?
        public var topTrailing: Character?
        public var bottomTrailing: Character?
        public var bottomLeading: Character?
     
        public static let defaults = Corners(
            topLeading: nil,
            topTrailing: nil,
            bottomTrailing: nil,
            bottomLeading: nil
        )

    }
    
    // MARK: - Vertical Padding
    
    public struct VerticalPadding: Equatable {
        
        // MARK: - Properties
        
        public var top: Int
        public var bottom: Int
        public var total: Int { top + bottom }
        
        public static let zero = VerticalPadding(top: 0, bottom: 0)

        // MARK: - Initialization
        
        /// Initialize padding.
        ///
        /// - Parameters:
        ///   - top: top padding.
        ///   - bottom: bottom padding.
        public init(top: Int = 0, bottom: Int = 0) {
            self.top = top
            self.bottom = bottom
        }
        
        // MARK: - Internal Methods
        
        func apply(lines: [Substring]) -> [Substring] {
            guard self != Self.zero else {
                return lines
            }
            
            return (
                [Substring](repeating: ""[...], count: self.top) +
                lines +
                [Substring](repeating: ""[...], count: self.bottom)
            )
        }
        
    }
    
}
