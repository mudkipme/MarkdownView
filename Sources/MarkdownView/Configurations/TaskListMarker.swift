//
//  TaskListMarker.swift
//  MarkdownView
//
//  Created by Codex on 2026/2/7.
//

import SwiftUI
import Markdown

struct AnyTaskListMarker {
    private let _makeBody: (ListItem) -> AnyView
    
    init<Marker: View>(
        @ViewBuilder _ marker: @escaping (ListItem) -> Marker
    ) {
        _makeBody = { listItem in
            marker(listItem).erasedToAnyView()
        }
    }
    
    @ViewBuilder
    func makeBody(listItem: ListItem) -> some View {
        _makeBody(listItem)
    }
}

private struct TaskListMarkerKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: AnyTaskListMarker? = nil
}

extension EnvironmentValues {
    var markdownTaskListMarker: AnyTaskListMarker? {
        get { self[TaskListMarkerKey.self] }
        set { self[TaskListMarkerKey.self] = newValue }
    }
}
