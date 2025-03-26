//
//  ObservedObject.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 26.03.25.
//

import SwiftUI

/// The `@ObservedObject` property wrapper is much simpler than `@StateObject`:
/// it doesn’t have the concept of an initial value, and it doesn’t maintain the observed
/// object across rerenders.
///
/// All it does is subscribe to the object’s `objectWillChange` publisher and
/// rerender the view when this publisher emits an event. This makes
/// `@ObservedObject` the only correct tool if we want to explicitly pass
/// objects from the outside into a view (when targeting platforms before iOS 17).
/// This is the equivalent of an `Observable` object within a regular property.
///
/// Here is what happens when the `ObservedObjectCounter` view is first created:
///
/// * **Step 1:** The wrapped value of the observed object property points to the model
/// instance we passed to the counter view.
/// * **Step 2:** The render node is created. In contrast to `@StateObject`, the node
/// only has a reference to the same external model object that we passed into the counter view.
/// * **Step 3:** The body of the counter view is executed, and the button view
/// is constructed. Inside the body, the button’s title uses the observed object’s
/// reference to the external model object. Then the render node is updated to
/// reflect the new view tree of the counter view.
struct ObservedObjectContentView: View {
    var body: some View {
        ObservedObjectCounter(model: ObservedObjectModel.shared)
    }
}

final class ObservedObjectModel: ObservableObject {
    @Published var value = 0

    static let shared = ObservedObjectModel()
}

struct ObservedObjectCounter: View {
    /// We could have written the following code instead:
    /// ```swift
    /// @ObservedObject var model = ObservedObjectModel.shared
    /// ```
    @ObservedObject var model: ObservedObjectModel

    var body: some View {
        Button("Increment: \(model.value)") {
            model.value += 1
        }
    }
}

// MARK: - Multiple Observed Objects

/// Here’s a simple example of a people counter for diﬀerent rooms:
///
/// For example, let’s imagine the counter is currently observing the “Living Room”
/// object. When the Counter gets rendered, the view tree and the render tree both
/// contain pointers to that object. Note that the render tree is responsible for
/// observing the object, but the view tree is still just a blueprint:
///
/// When the user selects the “Kitchen,” the counter view’s observed object now
/// has a reference to a diﬀerent model object.
///
/// As such, the render tree needs to be updated accordingly. First, the render
/// tree changes its reference to the model it’s observing, from the “Living Room”
/// model to the now-current “Kitchen” model.
///
/// Finally, the body of the counter view is reexecuted to construct a new view
/// tree, and the render tree is then updated accordingly.
///
/// > Important: Note that the node in the render tree for the counter view
/// doesn’t get recreated when we switch rooms; it just observes a diﬀerent object.
struct HallContentView: View {
    @State private var selectedRoom = "Hallway"
    var body: some View {
        VStack {
            Picker("Room", selection: $selectedRoom) {
                ForEach(["Hallway", "Living Room", "Kitchen"], id: \.self) { value in
                    Text(value).tag(value)
                }
            }
            .pickerStyle(.segmented)
            ObservedObjectCounter(model: HallModel.shared.counterModel(for: selectedRoom))
        }
    }
}

final class HallModel {
    static let shared = HallModel()
    var counters: [String: ObservedObjectModel] = [:]

    func counterModel(for room: String) -> ObservedObjectModel {
        if let m = counters[room] { return m }
        let m = ObservedObjectModel()
        counters[room] = m
        return m
    }
}

// MARK: - Previews

#Preview {
    ObservedObjectContentView()
}

#Preview("Multiple Observed Objects") {
    HallContentView()
}
