//
//  Transitions.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 16.04.25.
//

import SwiftUI

/// The animations that are applied to views when they are inserted or removed
/// from the view hierarchy are called **transitions**. Transitions are a powerful
/// way to animate the appearance and disappearance.
///
/// Let's first look into the API pre-iOS 17 and then discuss the new protocol-based
/// API introduced in iOS 17.
///
/// SwiftUI applies the default `.opacity` transition to views when they are inserted
/// or removed upon an animated state change.
///
/// Transitions have two states: _active_ and _identity_.  When a view is inserted,
/// it animates from the active state of the transtion to the identity state.
/// When it is removed, it animates from the identity state to the active state.
/// For the `.opacity` transition, the active is `.opacity(0)` and the identity
/// state is `.opacity(1)`.
///
/// So, this is the foundation of transitions in SwiftUI. We can use these two
/// states in SwiftUI to create our own custom transitions using
/// `AnyTransition.modifier(active:identity)`. Both parameters take a view
/// modifier that defines the state. The second example below shows how one could
/// implement `.opacity` transition using this API.
///
/// - Important: It isn't necessary for a view to be inserted or removed by an if
/// or switch statement for a transition to be applied. From SwiftUI's perspective,
/// just the view's identity needs to change. Thus, we can even use `.id_:)`
/// modifier to change the identity of a view and trigger the transition. See
/// the third example.
struct TransitionsContentView: View {
    @State private var flag = false

    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation { flag.toggle() }
            }
            if flag {
                Rectangle()
                    .frame(width: 100, height: 100)
                // To make it more explicit, we can add a transition modifier
                    .transition(.opacity)
            }

            if flag {
                Rectangle()
                    .frame(width: 100, height: 100)
                // To make it more explicit, we can add a transition modifier
                    .transition(.myOpacity)
            }

            Circle()
                .fill(.orange)
                .frame(width: 100, height: 100)
                .transition(
                    .asymmetric(insertion: .slide, removal: .scale)
                    .combined(with: .opacity)
                )
                .id(Int.random(in: 0...50))
        }
    }
}

// MARK: - Custom Opacity

private struct CustomOpacity: ViewModifier {
    var value: Double

    func body(content: Content) -> some View {
        content.opacity(value)
    }
}

private extension AnyTransition {
    static let myOpacity = AnyTransition.modifier(
        active: CustomOpacity(value: 0),
        identity: CustomOpacity(value: 1)
    )
}

// MARK: - Custom Blur Transition

private struct CustomBlur: ViewModifier {
    var value: CGFloat

    func body(content: Content) -> some View {
        content.blur(radius: value)
    }
}

private extension AnyTransition {
    static func customBlur(radius: CGFloat) -> AnyTransition {
        .modifier(
            active: CustomBlur(value: radius),
            identity: CustomBlur(value: 0)
        )
    }
}

/// In this example, we implement a custom transition that relies on the built-in
/// `.blur` modifier which is already animatable.
/// - Important: It is very important to note that transitions always work in
/// conjuction with animations. This means that just applying `.transition`
/// modifier to a view doesn't animate the change. We always need to apply
/// an implicit (`.animation`) or explicit (`withAnimation`) animation to
/// animate the state change that triggers the transition. If we use an implicit
/// animation, the animation shouldn’t be part of the subtree that gets removed
/// or inserted. Instead, we have to place the animation in a spot that’s stable
/// when the view gets inserted or removed. See the VStack below for an example.
struct CustomBlurTransitionContentView: View {
    @State private var flag = false

    var body: some View {
        Button("Toggle") {
            flag.toggle()
        }
        if flag {
            Rectangle()
                .frame(width: 100, height: 100)
                .transition(.customBlur(radius: 5))
            // This wouldn't work if you comment out `withAnimation` above.
                .animation(.easeInOut(duration: 0.5), value: flag)

        }

        // Remove the `withAnimation` and check the animation.
        VStack {
            if flag {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .transition(.customBlur(radius: 5))
            }
        }
        .animation(.default, value: flag)
    }
}

// MARK: - `Transition` Protocol introduced in iOS 17

/// To create a custom transition, we now can create a custom type conforming
/// to the `Transition` protocol. The concept of active and identity states has
/// been replaced by an explicit `TransitionPhase` type, which distinguishes
/// between the `willAppear`, `identity`, and `didDisappear` phases.
private struct BlurTransition: Transition {
    var radius: CGFloat

    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .blur(radius: phase.isIdentity ? 0 : radius)
    }
}

/// Convenience method just like built-in transitions.
private extension Transition where Self == BlurTransition {
    static func blur(radius: CGFloat) -> Self {
        BlurTransition(radius: radius)
    }
}

// MARK: - Previews

#Preview {
    TransitionsContentView()
}

#Preview("Custom Blur Transition") {
    CustomBlurTransitionContentView()
}
