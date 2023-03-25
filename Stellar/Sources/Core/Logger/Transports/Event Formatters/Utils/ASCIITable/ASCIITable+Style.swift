// ASCIITable+Style.swift

import Foundation

extension ASCIITable {
    
    /// Apply style to each column of the table.
    ///
    /// - Parameters:
    ///   - style: style to apply.
    ///   - columns: destination columns.
    func apply(style: Style, toColumns columns: inout [Column]) {
        guard !columns.isEmpty else {
            return
        }
        
        let hasMultipleColumns = (columns.count > 1)
        
        // First column
        columns[0].margins = .init(
            leading: "\(style.vertical)\(style.horizontalMargin)",
            trailing: "\(style.horizontalMargin)\(style.vertical)"
        )
        columns[0].footer = .init(
            border: style.horizontal,
            corners: (
                leading: style.upAndRight,
                trailing: (hasMultipleColumns ? style.upAndHorizontal : style.upAndLeft)
            )
        )
        columns[0].header?.borders = (top: style.horizontal, bottom: style.horizontal)
        columns[0].header?.margins = .init(
            leading: "\(style.vertical)\(style.horizontalMargin)",
            trailing: "\(style.horizontalMargin)\(style.vertical)"
        )
        columns[0].header?.corners = .init(
            topLeading: style.downAndRight,
            topTrailing: (hasMultipleColumns ? style.downAndHorizontal : style.downAndLeft),
            bottomTrailing: (hasMultipleColumns ? style.verticalAndHorizontal : style.verticalAndLeft),
            bottomLeading: style.verticalAndRight
        )
        
        let lastIndex = columns.endIndex.advanced(by: -1)
        guard lastIndex > 0 else {
            return
        }
        
        // Middle columns
        for index in 1 ..< lastIndex {
            columns[index].margins = .init(
                leading: style.horizontalMargin,
                trailing: "\(style.horizontalMargin)\(style.vertical)"
            )
            columns[index].footer = .init(
                border: style.horizontal,
                corners: (
                    leading: nil,
                    trailing: style.upAndHorizontal
                )
            )
            columns[index].header?.borders = (top: style.horizontal, bottom: style.horizontal)
            columns[index].header?.margins = .init(
                leading: style.horizontalMargin,
                trailing: "\(style.horizontalMargin)\(style.vertical)"
            )
            columns[index].header?.corners = .init(
                topLeading: style.horizontal,
                topTrailing: style.downAndHorizontal,
                bottomTrailing: style.verticalAndHorizontal,
                bottomLeading: style.horizontal
            )
        }
        
        // Last column
        columns[lastIndex].margins = .init(
            leading: style.horizontalMargin,
            trailing: "\(style.horizontalMargin)\(style.vertical)"
        )
        columns[lastIndex].footer = .init(
            border: style.horizontal,
            corners: (
                leading: style.horizontal,
                trailing: style.upAndLeft
            )
        )

        columns[lastIndex].header?.borders = (top: style.horizontal, bottom: style.horizontal)
        columns[lastIndex].header?.margins = .init(
            leading: style.horizontalMargin,
            trailing: "\(style.horizontalMargin)\(style.vertical)"
        )
        columns[lastIndex].header?.corners = .init(
            topLeading: style.horizontal,
            topTrailing: style.downAndLeft,
            bottomTrailing: style.verticalAndLeft,
            bottomLeading: style.horizontal
        )
        
    }
    
}
