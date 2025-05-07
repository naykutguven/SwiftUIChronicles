//
//  ObservableMacro.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 25.03.25.
//

import SwiftUI

/// `@Observable` macro is SwiftUI's mechanism for observing changes in objects.
/// It does two things:
/// - It adds conformance to `Observable` protocol.
/// - It changes the object’s properties to track both read and write access.
///
///The observation of an `Observable` object happens automatically just
///by accessing the object's properties.
/// * To couple the lifetime of an observable object to the lifetime of the view’s
/// render node (in other words, it’s an object that’s private to the view), we
/// declare the property using the `@State` property wrapper.
/// * To use an object with a lifetime independent of the view’s render node (in
/// other words, an object that we pass in from the outside), we just store it in a
/// normal property.
///
/// In iOS 17, the concepts of object lifetime and observation were separated.
struct ObservableMacroContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

/// Here is an example of using a model object instead of a value type.
@Observable
final class Model {
    var value = 0
}

/// From an ownership perspective, using `@State` together with an `Observable` object
/// works the same way as the `@State` example with a value type from the section above.
/// SwiftUI allocates memory for the object in the render tree node and keeps the object
/// alive as long as the node exists. The `@State` property wrapper’s wrapped value points
/// to this object.
struct CounterView: View {
    @State private var model = Model()

    var body: some View {
        Button("Increment: \(model.value)") {
            model.value += 1
        }
    }
}

// MARK: - Using Observable Objects without @State

/// Let's create an `Observable` object that has a shared instance.
@Observable
final class ModelShared {
    var value = 0
    static let shared = ModelShared()
}

/// Here is what happens when the counter is first created:
/// * Step 1. The model property points to the model instance we passed to the counter view.
/// * Step 2. The render node is created without any attached state, since the counter view
/// only has plain properties.
/// * Step 3. The body of the counter view is executed, and the button view is constructed.
/// Inside the body, the button’s title uses the external model object stored in the model
/// property of the counter view struct. Then, the render node is updated to reflect the
/// new view tree of the counter view.
///
/// Now, this looks like everything is working as expected. However, we had to create a
/// singleton object to share the model across views. This is not ideal.
///
/// Without @State, SwiftUI doesn’t have any lifetime responsibilities with regard to this
/// object, and observation happens automatically when the view’s body is executed and
/// the object’s properties are being accessed. Therefore, the render node of the counter
/// view doesn’t need to maintain any state itself.
///
/// The new macro-based object-observation model not only introduces a more
/// convenient syntax, but it also changes how the dependency between views and
/// observable objects is formed. With the new Observable macro, any property of an Observable
/// object we access in the view’s body will form a dependency to this view, no matter
/// where the object is coming from.
///
/// This new model is a lot simpler. For example, accessing a global singleton (that’s
/// observabl, **which is  what we did right below**) in a view body will
/// automatically form a dependency between the accessed property
/// and the view, without us having to pass this singleton into the view
/// using `@ObservedObject`.
///
/// > Important: The new model is also more eﬃcient. If you only use one
/// property of an object in your view’s body, changes to the other properties
/// won’t cause redraws of this view. Likewise, if you don’t use a model object
/// (for example, when it’s only in one branch of your code), the model
/// isn’t observed at all. This can reduce unnecessary view updates
/// and thus improve performance, whereas previously, we had to manually split up our
/// model objects to get more fine-grained view updates.
struct CounterShared: View {
    // We could also do `model = ModelShared.shared` here.
    var model: ModelShared
    var body: some View {
        Button("Increment: \(model.value)") {
            model.value += 1
        }
    }
}

struct CounterSharedContentView: View {
    var body: some View {
        CounterShared(model: ModelShared.shared)

        Button("This also increments: \(ModelShared.shared.value)") {
            ModelShared.shared.value += 1
        }
    }
}

// MARK: - How the Observable Macro Works

/// With `Observable` macro, two methods are added: `access` and `withMutating`.
/// Both methods forward the call to a matching method on the object’s observation
/// registrar. This registrar is responsible for keeping stock of the observers interested in
/// particular properties and notifying these observers when the properties change.
///
/// So how is the connection between an object’s properties and SwiftUI views formed?
///
/// There’s a global function, `withObservationTracking(_ apply:onChange:)`, which takes
/// two closures. The first closure, `apply`, is executed immediately, and the observation
/// system tracks which properties were accessed during apply. The second closure,
/// `onChange`, is the observer that’s called when any of the observable properties
/// accessed in the apply closure change.

// MARK: - Previews

#Preview {
    ObservableMacroContentView()
}

#Preview("Counter View with shared model, without @State") {
    CounterSharedContentView()
}
