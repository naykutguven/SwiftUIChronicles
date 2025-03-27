//
//  Bindings.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 27.03.25.
//

import SwiftUI

/// Bindings are used to create a two-way connection (read and write access)
/// between a view and its underlying data.
///
/// So, we can change the previously created `@State` based view to use a binding like this:
struct BindingCounterView: View {
    /// The whole point of switching to a binding is that it can be passed in from the outside.
    @Binding var value: Int

    var body: some View {
        Button("Increment: \(value)") {
            value += 1
        }
    }
}

struct BindingsContentView: View {
    @State private var value = 0
    var body: some View {
        BindingCounterView(value: $value)
    }
}

// MARK: - Let's write it without using the `@Binding` property wrapper

struct CounterViewWithoutBinding: View {
    var value: Int
    var setValue: (Int) -> Void

    var body: some View {
        Button("Increment: \(value)") {
            setValue(value + 1)
        }
    }
}

struct BindingsContentViewWithoutBinding: View {
    @State private var value = 0
    var body: some View {
        CounterViewWithoutBinding(value: value, setValue: {
            value = $0
        })
    }
}

// MARK: - Instead of using a closure, we can combine them using `Binding` type

struct CounterViewWithBindingType: View {
    var value: Binding<Int>

    var body: some View {
        Button("Increment: \(value.wrappedValue)") {
            value.wrappedValue += 1
        }
    }
}

// MARK: - If we want to get rid of writing `wrappedValue` we could:
/// ```swift
/// struct CounterWithBindingTypeWithoutWrappedValue: View {
///    var _value: Binding<Int>
///    var value: Int {
///        get { _value.wrappedValue }
///        set { _value.wrappedValue = newValue }
///    }
///
///    init(value: Binding<Int>) {
///        self._value = value
///    }
///
///    var body: some View {
///        Button("Increment: \(value)") { value += 1 } // raises an error, immutable value.
///    }
/// }
/// ```

// MARK: - Observable and Bindable

/// We can use `@Bindable` macro to make a property of an `Observable` object bindable.
/// `@State` property wrapper creates bindings to every property of an observable object automatically.
///
/// The `@Bindable` property wrapper allows us to get bindings from any property
/// in an `@Observable` object, including all SwiftData model objects. If you create
/// a local `@Observable` object using `@State`, you'll automatically be given bindings
/// by the `@State` property wrapper. However, if you've been passed an object without
/// any bindings – an object you know is `@Observable` – then you can use `@Bindable`
/// to create bindings for you.
///
/// If you can, it's preferable to use @Bindable directly on your property, like this:
/// ```swift
/// @Bindable var user: User
/// ```
///
/// However, that isn't possible in some situations, such as when you've used `@Environment` already. For times like that, use `@Bindable` directly in your view body, like this:
/// ```swift
/// @Bindable var user = user
/// ```
/// See [this post](https://www.hackingwithswift.com/quick-start/swiftdata/whats-the-difference-between-bindable-and-binding)
/// for detailed explanation.
struct WhyWeHaveBindableExplanation {}

// MARK: - Debugging Tip

/// To find out why a view’s body was reexecuted, we can use the `Self._printChanges()`
/// API in the view body like below:
///
/// This print statement will log the reason of the rerender to the console:
/// 1. If the view was rerendered due to a state change, the name of the state
/// property will be logged in its underscored form.
/// 2. If the view value itself has changed, i.e. if the value of one of the view’s
/// properties has changed, "`@self`" will be logged.
/// 3. If the identity of the view has changed, "`@identity`" will be logged. In practice,
/// this usually means the view was freshly inserted into the render tree.
///
/// Finally, there’s also a SwiftUI profiling template in Instruments, which we can use to
/// diagnose which view bodies are being executed more often than we’d expect.
struct DebuggingTip: View {
    var body: some View {
        let _ = Self._printChanges()
        Text("Hello, World!")
    }
}

// MARK: - Which Property Wrapper for What Purpose?

/// * **Regular Properties**: use regular properties without any property
/// wrappers in views whenever possible. If we just want to pass a value to a view
/// and the view doesn’t need write access to that value, a regular property is all we need.
///
/// * **`@State`**: Use it for private view state. When a view needs read and
/// write access to a value (not an object) and it should own that value as local,
/// private view state (which cannot be passed in from the outside), then we use `@State`.
///
/// * **`@Binding`**: If  the view needs read and write access to a value but
/// shouldn’t own that value (and doesn’t care where the value is actually stored),
/// then we use `@Binding`.
///
/// * **`@Observable`**: Post iOS 17 - If a view needs state in the form of an
/// object and the view should own that object as local, private view state
/// (which cannot be passed in from the outside), `@State` with an `@Observable` object.
///
/// * **`@StateObject`**: Pre iOS 17 - the same reason as above.
///
/// * **`@ObservedObject`**: if we need an object to be passed in from the outside,
/// then we use `@ObservedObject` pre-iOS 17.
///
/// > Important: A good rule of thumb is that `@State` and `@StateObject` should only
/// be used if a property can be initialized directly on the line where it’s declared.
/// If that doesn’t work, we should probably use `@Binding`, `@ObservedObject`,
/// or a plain property with an `@Observable` object.
struct WhichPropertyWrapperForWhatPurpose {}

// MARK: - Previews

#Preview {
    BindingsContentView()
}
