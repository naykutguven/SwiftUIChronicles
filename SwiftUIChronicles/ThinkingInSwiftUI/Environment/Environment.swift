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

#Preview {
    EnvironmentContentView()
}
