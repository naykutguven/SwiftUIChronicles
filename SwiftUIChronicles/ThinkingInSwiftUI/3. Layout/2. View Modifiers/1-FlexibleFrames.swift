//
//  FlexibleFrames.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 09.04.25.
//

import SwiftUI

/// Skipped the Padding and Fixed Frames sections as they are pretty simple.
///
/// The `frame` modifier allows us to set flexible frames. We can specify
/// minimum, maximum and ideal values for the view's width and height, and
/// also an alignment. The behavior can be a bit hard to grasp at first, but
/// once you get used to it, it's quite powerful.
///
/// Flexible frames apply min and max size limits twice:
/// 1. On the way in - before they propose a size to their subviews. The flexible
/// frame takes the proposed size and applies the min and max limits to it. And
/// then, it proposes the new size to its subviews.
///
/// 2. On the way out - after the subview reports its size back to the flexible frame.
/// The flexible frame takes the size reported by its subview and applies the min
/// and max limits to it to determine its own size.
/// >Important: If we specify only one end of the boundary for length — e.g. only
/// specify `minWidth`, but not `maxWidth` — the missing boundary value will
/// be substituted using the subview’s reported size. Then the proposed size gets
/// clamped by these boundaries and reported as the frame’s size.
/// >
/// > This means, if we specify only `minWidth`, the flexible frame will become
/// at least `minWidth` and at most the wisth of its subview. If we specify only
/// `maxWidth`, it will become at most `maxWidth` and at least the width of
/// its subview.
///
/// The first example below shows the `frame(maxWidth:.infinity)` pattern.
/// It makes the flexible frame become at least as wide as proposed or the width
/// of its subview, whichever is larger.
///
/// The second example shows the `frame(minWidth: 0, maxWidth: .infinity)`
/// pattern. It makes the flexible framethe frame always become exactly as wide as
/// proposed, independent of the size of its subview.
///
/// To put it in numbers, suppose:
/// 1. The frame proposes 300⨉460 to its subview.
/// 2. The text reports its size as 76⨉20.
/// 3. The frame’s width becomes **max(0, min(.infinity, 300)) = 300**.
///
/// **The max-min part here is important to understand how the frame works.**
///
/// If the `idealWidth` or `idealHeight` parameters are specified, this size
/// will be proposed to the frame’s subview, and it’ll also be reported as the
/// frame’s own size, regardless of the size of its subview.
struct FlexibleFramesContentView: View {
    var body: some View {
        Text("Hello, World!")
            .border(.blue)
            .frame(maxWidth: .infinity)
            .border(.red)
            .background(.quaternary)
        Text("Hello, World!")
            .frame(minWidth: 0, maxWidth: .infinity)
            .border(.blue)
            .background(.quaternary)
    }
}

// MARK: - Previews

#Preview {
    FlexibleFramesContentView()
}
