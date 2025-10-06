//
//  KeyframeBasedAnimations.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 17.04.25.
//

import SwiftUI

/// Keyframe-based animations are used to describe animations that transition
/// between discrete values specified in keyframes. They aren't built on top of
/// regular animations.
///
/// - Important: A keyframe animation animates a "single value" over time. It can
/// be a single double value (I think they mean tuple?) or a struct containing
/// multiple values. It is built out of one or more tracks - one track per property.
/// Suppose we have a struct with a rotation and an offset value. We can animate
/// each property independently using its own track. Think of a single track as
/// a timeline containing multiple items: each item describes how to move to the
/// next value. This description includes the target value, as well as the
/// duration, and how to interpolate.
///
/// Let's reimplement the hsake animation which needs only one track.
///
/// 1. The oﬀset will start at 0
/// 2. The first keyframe animates toward -30 during the first quarter of a second.
/// 3. The second keyframe animates toward 30 during the next half second.
/// 4. The final keyframe animates back to 0.
/// The cubic interpolation we choose here gives the animation a smooth ramp up
/// (starting with an initial velocity of 0) and also a smooth transition between
/// the keyframes.
struct KeyframeBasedAnimationsContentView: View {
    @State private var shakes = 0

    var body: some View {
        Button("Shake") {
            shakes += 1
        }
        .buttonStyle(.borderedProminent)
        .keyframeAnimator(
            initialValue: 0,
            trigger: shakes
        ) { content, offset in
            content.offset(x: offset)
        } keyframes: { value in
            CubicKeyframe(-30, duration: 0.25)
            CubicKeyframe(30, duration: 0.5)
            CubicKeyframe(0, duration: 0.25)
        }
    }
}

// MARK: Multiple tracks

/// We need to use `KeyframeTrack` to create two separate tracks, one for the
/// offset and the other for the rotation angle. While the keyframes within a
/// single track run in sequence, the tracks themselves run in parallel.
///
/// - Important: In general, tracks don’t have to have the same duration. If a
/// track ends while other tracks are still running, the track will report its
/// final value for the rest of the animation. Note that in the `keyframeAnimator`
/// method, we also receive the current value. Initially, this will be
/// `initialValue`, but if we tap again, this will be the final value of the
/// previous animation. If we trigger the animation before the previous animation
/// has ended, the closure’s `initialValue` will be the current (interpolated) value.
struct MultipleTracksKeyframeBasedAnimationsContentView: View {
    @State private var shakes = 0

    var body: some View {
        Button("Shake") {
            shakes += 1
        }
        .keyframeAnimator(
            initialValue: ShakeData(),
            trigger: shakes
        ) { content, data in
            content
                .offset(x: data.offset)
                .rotationEffect(data.rotation)
        } keyframes: { _ in
            KeyframeTrack(\.offset) {
                CubicKeyframe(-30, duration: 0.25)
                CubicKeyframe(30, duration: 0.5)
                CubicKeyframe(0, duration: 0.25)
            }
            KeyframeTrack(\.rotation) {
                LinearKeyframe(.degrees(20), duration: 0.1)
                LinearKeyframe(.degrees(-20), duration: 0.2)
                LinearKeyframe(.degrees(20), duration: 0.2)
                LinearKeyframe(.degrees(-20), duration: 0.2)
                LinearKeyframe(.degrees(20), duration: 0.2)
                LinearKeyframe(.degrees(0), duration: 0.1)
            }
        }

    }
}

private struct ShakeData {
    var offset: CGFloat = 0
    var rotation: Angle = .zero
}

// MARK: - Previews

#Preview {
    KeyframeBasedAnimationsContentView()
}

#Preview("Multiple tracks") {
    MultipleTracksKeyframeBasedAnimationsContentView()
}
