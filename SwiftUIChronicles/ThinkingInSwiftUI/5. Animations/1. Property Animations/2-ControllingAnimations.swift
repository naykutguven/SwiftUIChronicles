//
//  ControllingAnimations.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 15.04.25.
//

import SwiftUI

/// There are two ways of specifying when animations happen in SwiftUI:
/// 1. Implicit animations occur when a particular value changes.
/// 2. Explicit animations occur when a particular event happens.
///
/// The [`.animation(_:, value:)`](
/// https://developer.apple.com/documentation/swiftui/view/animation(_:value:))
/// modifier can be used to specify an implicit animation for a view. The first
/// parameter is the timing curve to use, and the second one specifies the value
/// that needs to change for the animation to be applied.
/// - SeeAlso:
///
/// The view tree for the example below:
/// .onTapGesture
/// |
/// |_ .animation
/// |
/// |_ frame
/// |
/// |_ Rectangle
///
///
/// - Tip: The `.animation` view modifier, i,e. implicit animations, animate
/// everything within their view subtree, so it’s important to place the modifier
/// in the correct spot. It’s generally a good idea to apply animations as locally
/// as possible to avoid unintended side eﬀects, especially when we make changes
/// to our code later on.
///
/// Another implicit animation modifier, [`animation(_:body:)`](https://developer.apple.com/documentation/swiftui/view/animation(_:body:))
/// is available in iOS 17.0+ and seems pretty useful. It allows us to scope
/// implicit animations to specific modifiers.
///
/// - Important: If we add a modifier which takes a different value based on
/// `flag` before the `.animation(_:body)` modifier, that modifier will change
/// the view without animation because the `.animation(_:body)` modifier only
/// animates the modifiers that are inside its body.
///
/// This new modifier comes with two pitfalls, though.
/// 1.  It doesn’t take a value parameter to control when the animation will take
/// eﬀect which means that the animatable modifiers within the body closure
/// will always animate when their parameters change, regardless of where
/// this change originated. It can come from outside, can be hard to debug.
///
/// 2. Some modifiers — like `.frame`, `.offset`, or `.foregroundColor` — might
/// have unexpected behavior in conjunction with animations. These modifiers take
/// eﬀect at the leaf view, and not at the position in the view tree where we
/// insert them. Therefore, these modifiers might still animate although there
/// was no animation present at the point in the view tree where we used them.
/// If we specify one of these “out-of-place” modifiers inside the body closure
/// of `.animation(_:body:)`, no animation will take place, because no animation
/// is present at the leaf view.
struct ControllingAnimationsContentView: View {
    @State private var flag = false

    var body: some View {
        VStack(spacing: 50) {

            Rectangle()
                .fill(.orange.gradient)
                .frame(width: flag ? 200 : 100, height: 100)
                .animation(.default, value: flag)
                .onTapGesture {
                    flag.toggle()
                }

            Rectangle()
                .fill(.red.gradient)
                .frame(width: 100, height: 100)
                // If we add a modifier which takes a different value based on `flag`,
                // the modifier will change the view without animation because
                // the `.animation(_:body)` modifier only animates the modifiers
                // that are inside its body.
                .animation(.default) {
                    $0.rotationEffect(flag ? .degrees(45) : .degrees(0))
                        .opacity(flag ? 0.1 : 1)
                }
                .onTapGesture {
                    flag.toggle()
                }

            Rectangle()
                .fill(.yellow.gradient)
                .frame(width: 100, height: 100)
                // If we add a modifier which takes a different value based on `flag`,
                // the modifier will change the view without animation because
                // the `.animation(_:body)` modifier only animates the modifiers
                // that are inside its body.
                .opacity(flag ? 0.1 : 1)
                .rotationEffect(flag ? .degrees(45) : .degrees(0))
                .animation(.default) {
                    $0.rotationEffect(flag ? .degrees(90) : .degrees(0))
                }
                .onTapGesture {
                    flag.toggle()
                }
        }
    }
}

// MARK: - Explicit Animations

/// This kind of unpredictability brings us to explicit animations which are made
/// by calling  `withAnimation` modifier.
struct ExplicitAnimationsContentView: View {
    @State private var flag = false

    var body: some View {
        VStack(spacing: 50) {
            Rectangle()
                .fill(.orange.gradient)
                .frame(width: flag ? 200 : 100, height: 100)
                .onTapGesture {
                    // Wrap the state changes that should be animated here.
                    withAnimation(.bouncy) { flag.toggle() }
                }
        }
    }
}

/// Binding animations are another way of creating explicit animations. One can
/// call `.animation` on a binding, then wrap the setter of the binding in an
/// explicit animation.
///
/// This version does exactly the same thing as theoriginal one above which is
/// much more straightforward. However, using an animation on a binding can be
/// a good option to apply an explicit animation without modifying the code of
/// the event closure (or without having an event closure at all).
struct ToggleRectangle: View {
    @Binding var flag: Bool
    var body: some View {
        Rectangle()
            .frame(width: flag ? 100 : 50, height: 50)
            .onTapGesture {
                flag.toggle()
            }
    }
}

struct BindingAnimationContentView: View {
    @State private var flag = false

    var body: some View {
        ToggleRectangle(flag: $flag.animation(.default))
    }
}

// MARK: - Previews

#Preview("Implicit Animations") {
    ControllingAnimationsContentView()
}

#Preview("Explicit Animations") {
    ExplicitAnimationsContentView()
    BindingAnimationContentView()
}
