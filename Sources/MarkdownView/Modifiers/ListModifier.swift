//
//  ListModifier.swift
//  MarkdownView
//
//  Created by Yanan Li on 2025/2/9.
//

import SwiftUI
import Markdown

extension View {
    /// Sets the indentation applied to each nested markdown list level.
    ///
    /// - Parameter indent: The indentation, in points, for each nested level.
    nonisolated public func markdownListIndent(_ indent: CGFloat) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.listConfiguration.leadingIndentation = indent
        }
    }
    
    /// Sets the marker used for unordered markdown list items.
    ///
    /// - Parameter marker: The marker style to use for unordered list items.
    nonisolated public func markdownUnorderedListMarker(_ marker: some MarkdownUnorderedListMarkerProtocol) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.listConfiguration.unorderedListMarker = AnyUnorderedListMarkerProtocol(marker)
        }
    }
    
    /// Sets the marker used for ordered markdown list items.
    ///
    /// - Parameter marker: The marker style to use for ordered list items.
    nonisolated public func markdownOrderedListMarker(_ marker: some MarkdownOrderedListMarkerProtocol) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.listConfiguration.orderedListMarker = AnyOrderedListMarkerProtocol(marker)
        }
    }
    
    /// Sets the spacing between top-level rendered markdown components.
    ///
    /// - Parameter spacing: The spacing, in points, between adjacent components.
    nonisolated public func markdownComponentSpacing(_ spacing: CGFloat) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.componentSpacing = spacing
        }
    }
}

extension View {
    /// Replaces the default task-list checkbox marker with a custom marker view.
    ///
    /// The marker is only used for list items containing task-list checkboxes (`- [ ]` / `- [x]`).
    nonisolated public func markdownTaskListMarker<Marker: View>(
        @ViewBuilder _ marker: @escaping (_ listItem: ListItem) -> Marker
    ) -> some View {
        environment(\.markdownTaskListMarker, AnyTaskListMarker(marker))
    }

    @available(*, deprecated, renamed: "markdownTaskListMarker")
    nonisolated public func taskListMarker<Marker: View>(
        @ViewBuilder _ marker: @escaping (_ listItem: ListItem) -> Marker
    ) -> some View {
        markdownTaskListMarker(marker)
    }
}
