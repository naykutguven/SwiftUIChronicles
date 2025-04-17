//
//  PhaseBasedAnimations.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 17.04.25.
//

import SwiftUI

/// THe phase animators look like the easiest way to implement "finish where you
/// started" kind of animations. We provide phases, discrete values which the
/// phase animator cycles through. Once a phase is completed, it will go
/// to the next one. Phase animators can loop infinitely or only once through
/// all phases every time the trigger value changes.
///
/// - Note: The phase needs to be `Equatable`.
/// - Tip: We could haveuse an enum with three cases for the phases for better
/// readability.
/// - Tip: The nice thing about this API is that we can specify separate animations
/// (timing curves) for each phase using the `animation` parameter.
struct PhaseBasedAnimationsContentView: View {
    @State private var shakes = 0

    var body: some View {
        Button("Toggle") {
            shakes += 1
        }
        .phaseAnimator([0, -20, 20], trigger: shakes) { content, offset in
            content.offset(x: offset)
        }
    }
}

// MARK: - Phase-based animations

#Preview {
    PhaseBasedAnimationsContentView()
}
