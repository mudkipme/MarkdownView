import Markdown
import SwiftUI

struct AnyTaskListMarker {
    private let makeMarker: (ListItem) -> AnyView

    init<Marker: View>(
        @ViewBuilder _ marker: @escaping (ListItem) -> Marker
    ) {
        makeMarker = { listItem in
            marker(listItem).erasedToAnyView()
        }
    }

    @ViewBuilder
    func makeBody(listItem: ListItem) -> some View {
        makeMarker(listItem)
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
