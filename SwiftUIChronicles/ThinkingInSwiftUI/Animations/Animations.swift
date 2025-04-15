//
//  Animations.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 14.04.25.
//

import SwiftUI

/// In SwiftUI, the only way to trigger a view update is to change the state of
/// the view. The changes between the old and new states aren't animated by default.
/// But there are different ways to animate the changes in the view.
///
/// When the user taps the circle, the `flag` is changed from `false` to `true`.
/// The `body` gets reexecuted. The new view tree is structurally the same but
/// the frame's width has changed from 50 to 100. Because the state change is wrapped
/// in `withAnimation` modifier, SwiftUI compares the new view tree to the current
/// render tree and looks for animatable changes. Almost all modifier parameters
/// are animatable.
///
/// Here, the `.default` timing curve (implicit in the call to `withAnimation`) is
/// used to generate progress values for the animation from 0 to 1. These progress
/// values are then used to interpolate the width of the circle from the old
/// width of 50 points to the new width of 100 points.
/// - Note: While you can think of the progress starting at zero and ending at
/// one, the values during the animation might be smaller than zero or larger
/// than one. For example, when you use iOS 17’s `.bouncy` timing curve, the
/// animation overshoots.
///
/// ## What's new for animations in iOS 17
///
/// - Animations have completion handlers that fire once an animation finishes.
/// - The `animation` modifier got a new overload that allows scoping an animation
/// to particular modifiers.
/// - We can now create completely custom animation curves using the new
/// `CustomAnimation` protocol.
/// - Phase-based animations allow us to specify a series of animations that
/// run automatically, one after the other, always returning to their starting value.
/// - Keyframe-based animations provide a new abstraction around creating
/// completely custom animations based on the interpolation of arbitrary values.
/// - New APIs for transitions, which center around the `Transition` protocol,
/// have been introduced.
struct AnimationsContentView: View {
    @State private var flag = false
    @State private var flagRed = false

    var body: some View {
        VStack(alignment: flagRed ? .leading : .trailing) {
            Circle().fill(.orange)
                .frame(width: flag ? 100 : 50)
                .onTapGesture {
                    withAnimation(.linear) { flag.toggle() }
                }
            Circle().fill(.red)
                .frame(width: flagRed ? 100 : 50)
                .onTapGesture {
                    withAnimation(.bouncy(extraBounce: 0.2)) { flagRed.toggle() }
                }
        }
        .border(.red)
    }
}

// MARK: - Property Animations vs. Transitions

/// In property animations, changes to the view’s properties are interpolated
/// but the views themselves are the same views (they have the same identities)
/// across the state change.
///
/// Now, consider the example below.
///
/// When the `flag` is false, only the subtree with narrower width will be present
/// in the render tree. Whenthe `flag` switches to true, the narrower subtree
/// is taken out of the render tree, and the wider subtree gets inserted. This
/// means that these two frame are different frames with diﬀerent identities,
/// because they’re located in diﬀerent positions within the view tree. Therefore,
/// SwiftUI doesn’t animate the `width` property of the frame, because there’s no
/// frame that’s part of the render tree before and after the state change.
///
/// When trying this example, the narrow circle fades out, and the wide circle
/// fades in. This is called a `transition`. Unlike property animations,
/// transitions are animations that are applied to views being removed from or
/// inserted into the render tree. We made a note on this and its performance
/// implications in the `View Trees` chapter.
struct PropertyAnimationsVSTransitionsContentView: View {
    @State private var flag = false

    var body: some View {
        // The circle does not have an identity yet.
        let circle = Circle()
            .fill(.green).onTapGesture {
                withAnimation(.linear) {
                    flag.toggle()
                }
            }
        if flag {
            // The circle has an identity now.
            circle
                .frame(width: 100)
        } else {
            // This is a different circle with a different identity.
            circle
                .frame(width: 50)
        }
    }
}

// MARK: - Previews

#Preview {
    AnimationsContentView()
    PropertyAnimationsVSTransitionsContentView()
}
