//
//  Anchors.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 19.04.25.
//

import SwiftUI

/// `Anchors` are pretty useful when we want to convert coordinates or sizes
/// between different coordinate spaces. This is usually the case when we work
/// with multiple views that are at different depths in the view hierarchy, meaning
/// they are in different coordinate spaces.
///
/// Anchors are essentially wrappers around a geometry value (`CGSize`, `CGRect`,
/// `CGPoint`) measured in **the global coordinate space**. This is important.
/// A geometry proxy has special support for anchors and lets us automatically
/// transform the geometry value into the local coordinate space. So, using a
/// `GeometryReader` is always a good idea when we want to use anchors. Let’s
/// take a look at the following example.
///
/// Imagine we want to implement an onboarding flow where we would like to draw
/// an ellipse around a view to highlight it.
///
/// If we implement it like in the first `VStack`, the ellipse is obscured by
/// the border of the `VStack` which is higher up in the view hierarchy.
/// - Important: In general, the ellipse might be obscured by siblings of the
/// login button, or by any other views that are higher up the view tree. In
/// this case, we want to draw the ellipse at the very top, even though its
/// position is determined by a view that’s possibly deep inside the hierarchy.
///
/// As we learned in the `Preferences` section, we can use preferences to
/// propogate the frame of the login button up the view hierarchy. Then we can
/// draw an overlay on top of the entire view tree.
///
/// Here are the steps we need to take:
/// 1. First, we need to create a preference key that will hold the frame of the
/// login button.
///
/// 2. Next, we need to set the preference key in the login button using the
/// `anchorPreference` modifier. This modifier will take a closure that returns the
/// frame of the login button in the global coordinate space, and propagate it
/// up the view hierarchy.
///
/// 3. Finally, we need to read the preference key in the parent view using the
/// `overlayPreferenceValue` modifier. This is a handy API compared to the
/// `onPreferenceChange` modifier, which we used in the `Preferences` section.
/// The latter would require us to create a separate state property.
///
struct AnchorsContentView: View {
    var body: some View {
        VStack(spacing: 100) {

            VStack {
                Button("Sign Up") {}
                Button("Log In") {}
                    .overlay {
                        Ellipse()
                            .strokeBorder(.red, lineWidth: 1)
                            .padding(-5)
                    }
            }
            .border(.green)

            VStack {
                Button("Sign Up") {}
                Button("Log In") {}
                    .anchorPreference(
                        key: HighlightPreferenceKey.self,
                        value: .bounds,
                        transform: { $0 }
                    )
            }
            .border(.green)
            .overlayPreferenceValue(HighlightPreferenceKey.self) { value in
                if let anchor = value {
                    // A `GeometryReader` and its proxy to resolve the anchor
                    // The `Anchor<CGRect>` is transformed into a `CGRect`
                    // within the local coordinate space
                    GeometryReader { proxy in
                        let rect = proxy[anchor]
                        Ellipse()
                            .strokeBorder(.red, lineWidth: 1)
                            .padding(-5)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.origin.x, y: rect.origin.y)
                    }
                }
            }
        }
    }
}

// MARK: - Highlight Preference Key

private struct HighlightPreferenceKey: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Value = nil

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value ?? nextValue()
    }
}

// MARK: - Previews

#Preview {
    AnchorsContentView()
}
