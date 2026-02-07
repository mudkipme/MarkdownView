//
//  ListModifier.swift
//  MarkdownView
//
//  Created by Yanan Li on 2025/2/9.
//

import SwiftUI
import Markdown

extension View {
    nonisolated public func markdownListIndent(_ indent: CGFloat) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.listConfiguration.leadingIndentation = indent
        }
    }
    
    nonisolated public func markdownUnorderedListMarker(_ marker: some UnorderedListMarkerProtocol) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.listConfiguration.unorderedListMarker = AnyUnorderedListMarkerProtocol(marker)
        }
    }
    
    nonisolated public func markdownOrderedListMarker(_ marker: some OrderedListMarkerProtocol) -> some View {
        transformEnvironment(\.markdownRendererConfiguration) { configuration in
            configuration.listConfiguration.orderedListMarker = AnyOrderedListMarkerProtocol(marker)
        }
    }
    
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
    nonisolated public func taskListMarker<Marker: View>(
        @ViewBuilder _ marker: @escaping (_ listItem: ListItem) -> Marker
    ) -> some View {
        environment(\.markdownTaskListMarker, AnyTaskListMarker(marker))
    }
}
