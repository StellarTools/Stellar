// ASCIITable+Components.swift

import Foundation

// MARK: - Column

extension ASCIITable {
        
    public struct Column: ExpressibleByStringLiteral {
        
        // MARK: - Attributes
        public var textAlignment: TextAlign = (h: .leading, v: .middle)
        public var verticalPadding: VerticalPadding = .zero
        public var minWidth = 0

        // MARK: - Style Properties
        
        var header: Header?
        var footer: Footer?
        var margins: Margins = .none
        var borders: Borders = (nil, nil)
        var corners: Corners = .defaults
        
        var hasFooter: Bool {
            self.footer.map(\.visible) ?? false
        }

        // MARK: - Initialization
        
        /// Initialize from plain string with default settings.
        ///
        /// - Parameter value: string value.
        public init(stringLiteral value: StringLiteralType) {
            self.init(title: value)
        }
        
        /// Initialize with title via configuration callback.
        ///
        /// - Parameters:
        ///   - title: title of the column.
        ///   - configure: (optional) configuration callback.
        public init(title: String, _ configure: ((inout Column) -> Void)? = nil) {
            self.header = .init(title: title)
            configure?(&self)
        }
    
    }
    
}

// MARK: - Column Header

extension ASCIITable.Column {
 
    public struct Header {
        
        // MARK: - Attributes
        
        public var title: String
        public var textAlignment: ASCIITable.TextAlign = (.center, .middle)
        public var verticalPadding: ASCIITable.VerticalPadding = .zero
        public var minHeight = 0

        // MARK: - Style Properties

        var margins: ASCIITable.Margins = .none
        var borders: ASCIITable.Borders = (nil, nil)
        var corners: ASCIITable.Corners = .defaults

        var decorationHeight: Int {
            (self.borders.bottom != nil ? 1 : 0) +
            (self.borders.top != nil ? 1 : 0) +
            self.verticalPadding.total
        }
        
        // MARK: - Initialization
        
        /// Initialize with title via configuration callback.
        ///
        /// - Parameters:
        ///   - title: title of the header.
        ///   - configure: (optional) configuration callback.
        public init(title: String, _ configure: ((inout Header) -> Void)? = nil) {
            self.title = title
            configure?(&self)
        }
        
    }
    
}
    
// MARK: - Column Footer

extension ASCIITable.Column {
 
    struct Footer {
        
        // MARK: - Style Attributes
        
        var border: Character?
        var corners: (leading: Character?, trailing: Character?)
        
        var visible: Bool {
            self.border != nil ||
            self.corners.leading != nil ||
            self.corners.trailing != nil
        }
        
        var cornerLength: Int {
            (self.corners.leading != nil ? 1 : 0) +
            (self.corners.trailing != nil ? 1 : 0)
        }
        
    }
    
}

// MARK: - Table Style

extension ASCIITable {
    
    public struct Style {
        
        // MARK: - Table Components Blocks
        
        var horizontal: Character = "─"
        var vertical: Character = "│"
        var downAndLeft: Character = "┐"
        var downAndRight: Character = "┌"
        var upAndLeft: Character = "┘"
        var upAndRight: Character = "└"
        var upAndHorizontal: Character = "┴"
        var downAndHorizontal: Character = "┬"
        var verticalAndLeft: Character = "┤"
        var verticalAndRight: Character = "├"
        var verticalAndHorizontal: Character = "┼"
        var horizontalMargin = " "
        var filler: Character = " "
        
        public static let `default`: Style = .init()
        
    }
    
}
