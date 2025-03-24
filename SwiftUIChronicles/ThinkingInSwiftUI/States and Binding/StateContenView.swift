//
//  StateContenView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 24.03.25.
//

import SwiftUI

/// Now, we have established that view trees are constructed as blueprints and translated
/// into the persistent render tree. SwiftUI handles this translation process for us.
/// In general, the update cycle can be summarized as follows:
/// - The view tree is constructed.
/// - The nodes in the render tree are created, updated, or removed to match the current view tree.
/// - Some event causes a state change.
/// - This process repeats.
///
/// In principle, we don't need to worry about this process. However, understanding which parts of
/// the view tree are being rerendered and for what reason can help us optimize our views.
///
/// There are several different wrapper types for state in SwiftUI such as
/// `@State`, `@StateObject`, `@ObservedObject`.
///
/// >Important: As of iOS 17, the way SwiftUI interfaces with objects has changed completely. SwiftUI
/// no longer relies on the Combine framework for observation, and instead uses a
/// macro-based solution, which also renders the `@StateObject` and `@ObservedObject`
/// property wrappers superfluous. The `@State` property wrapper is now used for values
/// and objects, whereas we usually only used it for values pre-iOS 17.
struct StateContenView: View {
    /// `@State` is meant to be used for private view state values.
    ///
    /// During the execution of the `body` property, SwiftUI notices that the
    /// state property is accessed, and it adds a dependency between the `value` state property
    /// and the counter view’s node in the render tree. As a result, whenever value changes
    /// (e.g. because the button is tapped), SwiftUI will reexecute the counter view’s body.
    ///
    /// >Note that if we don’t include the value inside the button’s label, SwiftUI is
    /// smart enough to figure out that it doesn’t need to rerender the counter’s body
    /// when the state property changes.
    @State private var value = 0
    var body: some View {
        Button("Increment: \(value)") {
            value += 1
        }
    }
}

/// Now, you might think that `value` is 0 every time the view is reinitialized. However,
/// this is not the case. Let's look at the same view without `@State` property wrapper.
/// SwiftUI keeps track of the state properties of the view and
/// makes sure that they are preserved across view reinitializations.
///
/// The inital value here is the value that is used when the node for the view
/// is first created in the render tree.
struct Counter: View {
    private var _value = State(initialValue: 0)
    private var value: Int {
        get { _value.wrappedValue }
        nonmutating set { _value.wrappedValue = newValue }
    }
    var body: some View {
        Button("Increment: \(value)") {
            value += 1
        }
    }
}

/// We are going to consider two scenarios
/// 1. When the button is first created and 2. When the button is tapped.
///
/// **1. When the button is first created:**
///
/// **Step 1:** When the Counter struct is constructed for the first time, no corresponding
/// node in the render tree exists yet. The state property `value` has two properties:
/// `initialValue`, which is the value we assigned during initialization of
/// the property, and `wrappedValue`, which is the value we’re interacting with
/// in the view’s body. We can think of `wrappedValue` as a pointer to the actual value
/// of this state property, which currently doesn’t point to anything yet.
///
/// **Step 2.** When SwiftUI creates the counter view’s node in the render tree,
/// it allocates memory for the view’s state property. The system initializes the memory
/// for the value property in the render node with the state property’s `initialValue` of 0.
/// **The wrapped value of the state property now points to the memory in the render node.**
/// We established the dependency connection between the state property and the render node.
///
/// **Step 3.** The view’s body gets executed and the Button view is created. Since the
/// wrapped value of the state property now points to the memory in the render node,
/// the value stored in the render node is used when constructing the button’s title.
///
/// **Step 4.** Using the counter view’s body as a blueprint, the button view in the render
/// node is created.
///
/// **2. When the button is tapped:**
///
/// **Step 1.**  Because the value property — which is really `_value.wrappedValue` —
/// is a pointer to the memory in the render tree, that memory will be incremented.
///
/// **Step 2.** Because the counter’s body is dependent on that state memory,
/// it’s reexecuted, and a new button view will get constructed. Accessing the value property
/// for the button’s title will now return 1 (even though the initial value of the state property is still 0).
/// So, the view tree is recreated.
///
/// **Step 3.** Using the newly constructed view tree of the counter view as a blueprint, the
/// button’s title (in the render tree) changes to the new value.

// MARK: - Why Should We Have Private State Properties and Why Should We Not Assign State Properties inside the View Initializer?

struct CounterWithInjectedInitialValue: View {
    @State private var value: Int

    /// Now we can pass the value in from the outside, but this only changes the initial value
    /// of the state property, since we don’t have access to the state’s current value in the
    /// view’s initializer. Once the node for this view has been created in the render tree,
    /// passing in a diﬀerent initial value will have no eﬀect — or at least not the eﬀect we
    /// might expect. All that’s happening is that the initial value (not the actual value!) gets
    /// changed, which will only have an eﬀect if the node is removed and reinserted into the
    /// render tree.
    ///
    /// So, say, you pass 5 later on. This will only change the initial value of the state property,
    /// not the actual value. The actual value is still 0. The initial value is only used when the
    /// node is created in the render tree. If the node is removed and reinserted, the initial value
    /// will be used. But as long as the node is in the render tree, the actual value is used.
    init(value: Int = 0) {
        _value = State(initialValue: value)
    }

    /// The init below is also wrong. As we’ve seen before, the `self.value = value`
    /// statement actually translates to `self._value.wrappedValue = value`.
    /// It still won’t do what we’d expect.  The reason that the assignment in the initializer
    /// below doesn’t work is twofold: **the state of a view is coupled to its identity,
    /// and at the time the initializer runs, the view doesn’t yet have identity.
    ///
//    init(value: Int = 0) {
//        self.value = value
//    }

    var body: some View {
        Button("Increment: \(value)") {
            value += 1
        }
    }
}

// MARK: - Previews

#Preview {
    StateContenView()
}

#Preview("Counter with injected initial value") {
    CounterWithInjectedInitialValue()
}
