//
//  HStackVStack.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 10.04.25.
//

import SwiftUI

/// Even though `HStack` and `VStack` work intuitively most of the time, their
/// layout algorithm  is quite complex. We will only look at `HStack` examples
/// since it works in the exact same way for `VStack`, just the axis is switched.
/// Let's dive in.
///
/// In the first example below, the text is rendered as expected, in a single line
/// because there is enough space. However, if we change the frame width to 300,
/// the text is wrapped even though the `HStack` has enough space to fit the text.
/// This is because of how `HStack` divides the available space among its
/// subviews. To put it simply:
///
/// 1. First, the stack determines the "flexibility" of its subviews. The colors
/// here are infinitely flexible, they become any size proposed. The `Text` view
/// has a limit – it can become zero or its ideal size, never larger than that.
///
/// 2. The stack sorts the subviews by their flexibility, from least to most flexible.
/// It keeps track of the remaining width and its subviews.
///
/// 3. While there are remaining subviews, the stack proposes the remaining width,
/// divided by the number of remaining subviews.
///
/// To make it more concrete, let's take a look at the second `HStack` example.
/// 1. The stack is proposed a width of 270. The least flexible subview, `Text`, is
/// proposed a width of 270/3 = 90.
/// 2. The text view calculates its ideal size as 97.33 x 20.33, which is larger
/// than the proposed size. So, it truncates/wraps as needed and reports back
/// a size of 49.66 x 42.33.
/// 3. The stack now has 270 - 49.66 = 220.34 remaining width. It proposes
/// 220.34/2 = 110.17 to the next subview, and 110.16/1 = 110.16 to the last.
///
/// To mitigate this issue, we could call `fixedSize()` on the text view. However,
/// this doesn't work well when the stack is already smaller than the text's ideal size.
/// Instead, we can use `layoutPriority()` to give the text view a higher priority.
///
/// The informal algorithm then becomes:
///
/// 1. Determine the flexibility of all subviews by proposing both `0 ⨉ proposedHeight`
/// and `infinity ⨉ proposedHeight` to each subview (this process of proposing
/// multiple sizes to a subview is also called **probing**). The flexibility is the
/// diﬀerence of the two resulting widths.
/// 2. Group all the subviews according to their layout priorities.
/// 3. Start with the proposed width, and subtract the minimum widths of all
/// subviews, as well as the spacing between them. The result is the `remainingWidth`
/// (this might be nil if the proposed width was nil).
/// 4. While there are remaining groups:
///     1. Pick the group with the highest layout priority.
///     2. Add the sum of all minimum widths of the subviews in this group back
///     to the `remainingWidth`.
///     3. While there are remaining views in the group:
///         1. Pick the view with the smallest flexibility.
///         2. Propose
///         (`remainingWidth/numberOfRemainingViews)⨉proposedHeight`.
///         3. Subtract the view’s reported width from `remainingWidth`.
struct HStackVStackContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            Color.teal
            /// we can use `.onGeometryChange` in iOS 18, instead of this
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Teal 1 size: \(geometry.size)")
                        }
                })
            Text("Hello, World!")
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Text 1 size: \(geometry.size)")
                        }
                })
            Color.cyan
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Cyan 1 size: \(geometry.size)")
                        }
                })
        }
        .frame(width: 350, height: 200)

        HStack(spacing: 0) {
            Color.teal
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Teal 2 size: \(geometry.size)")
                        }
                })
            Text("Hello, World!")
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Text 2 size: \(geometry.size)")
                        }
                })
            Color.cyan
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Cyan 2 size: \(geometry.size)")
                        }
                })
        }
        .frame(width: 270, height: 200)

        HStack(spacing: 0) {
            Color.teal
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Teal 3 size: \(geometry.size)")
                        }
                })
            Text("Hello, World!")
                .layoutPriority(.infinity)
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Text 3 size: \(geometry.size)")
                        }
                })
            Color.cyan
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Cyan 3 size: \(geometry.size)")
                        }
                })
        }
        .frame(width: 270, height: 200)
    }
}

#Preview {
    HStackVStackContentView()
}
