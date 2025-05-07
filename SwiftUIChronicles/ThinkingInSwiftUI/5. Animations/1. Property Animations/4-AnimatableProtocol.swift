//
//  AnimatableProtocol.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 16.04.25.
//

import SwiftUI

/// The `Animatable` protocol can be used to specify and expose animatable
/// properties  of views and view modifiers to SwiftUI.
///
/// The only requirement of the `Animatable` protocol is the `animatableData`
/// property which has a default implememtation that does nothing, so be careful.
/// The type of `animatableData` has to conform the `VectorArithmetic` protocol
/// so that SwiftUI can multiply the value with a float and add values to
/// interpolate between the values.
///
/// SwiftUI inspects each view and looks for animatable data properties that
/// have changed. Then it interpolates the change using the timing curve of the
/// current animation. Each interpolated value is set through the `animatableData`
/// property which will reexecute the view's or view modifier's body.
///
/// In the example below, SwiftUI will look for the `animatableData` property.
/// It will start to interpolate the opacity value from 0.3 to 1.0 using the linear
/// timing curve with a duration of 1 second. Assuming 60 frames per second,
/// the opacity view modifier’s animatable data property will be set 60 times,
/// with the interpolated values.
struct AnimatableProtocolContentView: View {
    @State private var flag = false

    var body: some View {
        Circle().fill(.red.gradient)
            .frame(width: 200)
            .opacity(flag ? 1 : 0.3)
            .animation(.linear(duration: 1.0), value: flag)
            .onTapGesture {
                flag.toggle()
            }

        Rectangle().fill(.orange.gradient)
            .frame(width: 200, height: 200)
            .modifier(MyOpacity(opacity: flag ? 1 : 0.3))
            .animation(.linear(duration: 1.0), value: flag)
    }
}

private struct MyOpacity: ViewModifier, Animatable {
    var animatableData: Double

    init(opacity: Double) {
        animatableData = opacity
    }

    func body(content: Content) -> some View {
        let _ = print("animatableData: \(animatableData)")
        content
            .opacity(animatableData)
    }
}

// MARK: - "Finish where you started" type of animations prior to iOS 17

/// The `Animatable` protocol can be used to create animations that
/// finish where they started. We can use either phase animations or keyframe
/// animations to achieve this as of iOS 17.0, which we will discuss later in
/// `Transitions` section.
private struct Shake: ViewModifier, Animatable {
    var numberOfShakes: Double
    var animatableData: Double {
        get { numberOfShakes }
        set { numberOfShakes = newValue }
    }
    func body(content: Content) -> some View {
        content
            .offset(x: -sin(numberOfShakes * 2 * .pi) * 30)
    }
}

struct FinishWhereStartedAnimationContentView: View {
    @State private var shakes = 0
    var body: some View {
        Button("Shake!") { shakes += 1 }
            .buttonStyle(.borderedProminent)
            .modifier(Shake(numberOfShakes: Double(shakes)))
            .animation(.default, value: shakes)
    }
}

// MARK: - Previews

#Preview {
    AnimatableProtocolContentView()
    FinishWhereStartedAnimationContentView()
}
