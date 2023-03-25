// ASCIITable.swift

import Foundation

public struct ASCIITable {
    
    // MARK: - Public Properties
    
    /// Columns list.
    public private(set) var columns: [Column]
    
    /// The content of the table.
    public let content: [TerminalRepresentable]
    
    /// Style used to draw the table.
    public let style: Style
    
    // MARK: - Initialization
    
    /// Initialize a new table.
    ///
    /// - Parameters:
    ///   - style: defines the style of the table structure.
    ///   - columns: columns of the table.
    ///   - content: content of the table.
    public init(style: Style = .default,
                columns: [Column],
                @TerminalDisplayElementsBuilder content: () -> [TerminalRepresentable]) {
        self.columns = columns
        self.style = style
        self.content = content()
        apply(style: style, toColumns: &self.columns)
    }
    
}
