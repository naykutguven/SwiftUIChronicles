//
//  CustomEnvironmentKeys.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 13.04.25.
//

import SwiftUI

/// The example below relies on `tint` environment key for the badge color.
/// But instead, we can create our own environment key and use it in the same way.
///
/// The steps are:
/// 1. Create a custom environment key for the badge color and associate the
/// `Color` type with the key.
/// 2. Implement an extension on `EnvironmentValues` with a property that lets
/// us get and set the value.
/// 3. Optionally, a helper method on `View` to easily set the badge color for
/// an entire subtree. This lets us hide the custom key and extension, and
/// it provides a discoverable API for users.
struct CustomEnvironmentKeysContentView: View {
    var body: some View {
        VStack {
            Text(3000, format: .number)
                .badge()
            Text("Hello, world!")
                .badge()
        }
        .tint(.orange)

        VStack {
            Text(3000, format: .number)
                .badge()
            Text("Hello, world!")
                .badge()
        }
        .badgeColor(.red) // Our custom environment key
    }
}

// MARK: - Badge ViewModifier

private struct Badge: ViewModifier {
    /// The badge color is passed down from the environment. This is needed to
    /// read the custom environment key we created below.
    @Environment(\.badgeColor) private var badgeColor

    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background {
                Capsule(style: .continuous)
//                Initially, we read the tint color from the environment key as
//                mentioned in the first sentence.
//                    .fill(.tint)
                    .fill(badgeColor) // uses the current tint color
            }
    }
}

// MARK: - Convenience extension

private extension View {
    func badge() -> some View {
        modifier(Badge())
    }
}

// MARK: - 1. Custom Environment Key

/// The environment key is used to pass the badge color down the view hierarchy.
/// Its associated value is a `Color` type.
enum BadgeColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

// MARK: - 2. EnvironmentValues extension

private extension EnvironmentValues {
    var badgeColor: Color {
        get { self[BadgeColorKey.self] }
        set { self[BadgeColorKey.self] = newValue }
    }
}

// MARK: - 3. Convenience method

private extension View {
    func badgeColor(_ color: Color) -> some View {
        environment(\.badgeColor, color)
    }
}

// MARK: - Previews

#Preview {
    CustomEnvironmentKeysContentView()
}
