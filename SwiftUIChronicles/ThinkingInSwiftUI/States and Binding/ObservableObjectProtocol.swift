//
//  ObservableObjectProtocol.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 26.03.25.
//

import SwiftUI

/// Prior to iOS 17, SwiftUI used the `ObservableObject` protocol to create observable objects
/// together with either `@ObservedObject` or `@StateObject` property wrappers.
///
/// The `@StateObject` property wrapper works much in the same way as `@State`:
/// we specify an initial value (an object in this case), which will be used as the starting point
/// when the node in the render tree is created. From then on, SwiftUI will keep this
/// object around across rerenders for the lifetime of the node in the render tree.
///
/// But how does it work behind the scenes?
///
/// * **Step 1:**  The counter view is created, but the value of the state
/// object isn’t present yet, because the initial value is stored as an autoclosure.
/// * **Step 2:** The counter node in the render tree is created, and the memory
/// for the state object is initialized with the value returned by the autoclosure.
/// The wrapped value of the `StateObject` struct points to the model object
/// stored in the render tree.
/// * **Step 3:** The counter view’s body is executed, the button view is created,
/// and the current value of the model object from the render tree is used for the button’s label.
/// * **Step 4:** The node in the render tree is updated using the button view as a blueprint.
///
/// > Important: Just as with `@State`, `@StateObject` should be used for private
/// view state; we shouldn’t try to pass objects in from the outside or create objects
/// in the view’s initializer and assign them to the state object property. This
/// doesn’t work for the same reason we mentioned when talking about `@State`:
/// **when the view’s initializer runs, the view doesn’t yet have identity.**
///
/// > Important: As a rule of thumb, we should only use `@StateObject` when
/// we can assign an initial value to the property on the line where we declare the property.
///
/// > Important: the`Observable` implementation tracks changes at the property level,
/// whereas the `@StateObject` tracks changes at the object level. Also, the
/// `@StateObject` initializer takes an autoclosure, whereas the `@State` property
/// will evaluate its initial value every time the view is initialized.
struct CounterStateObjectView: View {
    /// So, without the `@StateObject` property wrapper, it would look like this:
    /// ```swift
    /// private var _model = StateObject(wrappedValue: Model())
    /// private var model: Model { _model.wrappedValue }
    /// ```
    @StateObject private var model = StateObjectModel()

    var body: some View {
        Button("Increment: \(model.value)") {
            model.value += 1
        }
    }
}

final class StateObjectModel: ObservableObject {
    /// Here, we rely on the default implementation of `objectWillChange` publisher
    /// that we get for free from the `ObservableObject` protocol, and we used
    /// the `@Published` property wrapper to send an event before our value
    /// property changes. Instead of using `@Published`, we could also write
    /// the following:
    /// ```swift
    /// var value = 0 {
    ///     willSet { objectWillChange.send() }
    /// }
    /// ```
    @Published var value = 0
}

// MARK: - Previews

#Preview {
    CounterStateObjectView()
}
