//
//  MarkdownTableHeader.swift
//  MarkdownView
//
//  Created by LiYanan2004 on 2025/4/21.
//

import SwiftUI
import Markdown

struct MarkdownTableRow: View {
    private var rowIndex: Int
    private var cells: [MarkdownTableStyleConfiguration.Table.Cell]
    @Environment(\.markdownTableCellPadding) private var padding
    
    init(
        rowIndex: Int,
        cells: [MarkdownTableStyleConfiguration.Table.Cell]
    ) {
        self.rowIndex = rowIndex
        self.cells = cells
    }
    
    var body: some View {
        GridRow {
            ForEach(renderableCells, id: \.offset) { (index, cell) in
                cell.content
                    .multilineTextAlignment(cell.textAlignment)
                    .gridColumnAlignment(cell.horizontalAlignment)
                    .gridCellColumns(cell.colspan)
                    ._markdownCellPadding(padding)
                    .modifier(
                        MarkdownTableStylePreferenceSynchronizer(
                            row: rowIndex,
                            column: index
                        )
                    )
            }
        }
    }

    var renderableCells: [(offset: Int, element: MarkdownTableStyleConfiguration.Table.Cell)] {
        // The parser retains cells covered by a preceding colspan with a zero
        // span. They preserve column indexes, but are not SwiftUI Grid children.
        Array(cells.enumerated()).filter { $0.element.colspan > 0 }
    }
}
