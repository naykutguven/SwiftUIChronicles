//
//  Environment.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 13.04.25.
//

import SwiftUI

/// The environment  is a powerful mechanism in SwiftUI that is a built-in
/// technique for dependency injection and makes the code so compact.
///
/// In the example below, the view tree is like this:
/// HStack
/// |
/// |_ EnvironmentKeyModifier(Font?)
/// |   |
/// |   |_ VStack
/// |   |   |_ Text
/// |   |   |_ Text
/// |
/// |_ Text
///
/// The `.font` modifier is translated into an `EnvironmentKeyModifier` with
/// a value of `Font?`.
/// We could also write it as follows which results in the same view tree:
/// ```swift
/// VStack {
///     Text("Hello, World!")
///     Text("Hello, World!")
/// }
/// .environment(\.font, .largeTitle)
/// ```
///
/// Let's take a look at the operator's signature:
/// ```swift
/// nonisolated
/// func environment<V>(
///    _ keyPath: WritableKeyPath<EnvironmentValues, V>,
///    _ value: V
/// ) -> some View
/// ```
/// The first parameter is a key path in `EnvironmentValues` which we can think of
/// as a dictionary a dictionary of all the environment values.
///
/// The environment mechanism is SwiftUI's way of passing data down the view
/// hierarchy without having to pass it explicitly through each view.
/// In our example, this means that all views downstream from the
/// `EnvironmentKeyWritingModifier` — the `VStack`, as well as both `Text`
/// views — can read the font value specified from the environment. Views
/// upstream from the `EnvironmentKeyWritingModifier` or in other branches of
/// the view tree cannot see the custom value we set here.
///
/// Think of the environment as a dictionary with keys and values that’s passed
/// from the root of the view tree all the way down to the leaf nodes. At any
/// point in the view tree, we can change the value for a key by writing into the
/// environment. The subtree beneath the environment writing modifier will then
/// receive that modified environment.
///
/// >Tip: The environment is also used to make “global” settings such as the current
/// locale or the time zone available to every view in the app.
struct EnvironmentContentView: View {
    var body: some View {
        HStack {
            VStack {
                Text("Hello, World!")
                Text("Hello, World!")
            }
            .font(.largeTitle) // or .environment(\.font, .largeTitle)

            Text("Hello, World!")
        }
    }
}

// MARK: - Reading from the Environment

/// We can read from the environment using the `@Environment` property wrapper.
/// This gives access to a specific value in the environment and observes the
/// environment for any changes to that value. This means that in SwiftUI, any time an
/// environment value, for example current locale, changes, all views that read
/// that value will be re-rendered. So, we don't need extra mechanisms to
/// auto-update the current locale.
///
/// >Important: Note that the content view will rerender any time the observed
/// environment value changes. So, it is important to be careful about the granularity
/// of the environment values we use for better performance. See the example below.
///
/// >Important: Similar to `@State` properties, it doesn’t make sense to expose
/// `@Environment` properties to the outside. Therefore, we typically mark them
/// as private and use a linting rule to verify that they’re private. Another
/// similarity to state properties is that we can only read from the environment
/// inside the body of a view; we cannot read from the environment inside
/// a view’s initializer, as the view doesn’t yet have identity at that point.
/// When we do try to read an environment property in the view’s initializer,
/// we’ll get a runtime warning.
struct ReadingFromEnvironmentContentView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.dynamicTypeSize.isAccessibilitySize) private var isAccessibilitySize

    var body: some View {
        VStack {
            Text("Hello, World!")
            if dynamicTypeSize > .large {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(.green)
            }
            if isAccessibilitySize {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    EnvironmentContentView()
}

#Preview("Reading from Environment") {
    ReadingFromEnvironmentContentView()
    // We can either set the environment value here or click on
    // the `Variants` button in the rendered preview
        .environment(\.dynamicTypeSize, .xLarge)
    ReadingFromEnvironmentContentView()
    // We can either set the environment value here or click on
    // the `Variants` button in the rendered preview
        .environment(\.dynamicTypeSize, .accessibility3)
}
