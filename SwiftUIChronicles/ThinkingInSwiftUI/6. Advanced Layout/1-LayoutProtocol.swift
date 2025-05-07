//
//  LayoutProtocol.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 18.04.25.
//

import SwiftUI

/// Layout primitives in SwiftUI don't give us much information about what sizes
/// are proposed to views, the size of sibling views or subviews. We need to use
/// more low-level techniques to implement layouts that depend on this kind of
/// information.
///
/// The `Layout` protocol was introduced to create custom layout containers  in
/// iOS 16 which works as follows:
///
/// 1. The container size is determined using the sizeThatFits method. Inside
/// that method, we get access to the subviews through their proxies. Each proxy
/// allows us measure a subview by proposing various sizes.
///
/// 2. Then the subviews are placed within the container’s size. Again, we have
/// access to the subviews through their proxies.
///
/// ## Layout Protocol
/// The `Layout` protocol allows us to build custom container views that lay out
/// their subviews according to an algorithm we write. For example, we can use
/// the protocol to build custom layouts such as masonry layouts, flow layouts,
/// or circular layouts. The videos from WWDC22 are great resources to learn.
///
/// We are going to implement a custom flow layout here as  follows:
/// 1. Ask each of the subviews for its ideal size by proposing nil⨉nil.
/// 2. Compute the positions of all subviews based on the container’s own size.
/// 3. Place each subview based on the positions computed in step 2.
///
/// The step 2 works like this:
/// 1. We keep track of the current position as a CGPoint starting at (0, 0).
/// The x component is the current horizontal position within the line, and it
/// changes with each additional view. The y component is the top of the current
/// line, and it only changes when we start a new line.
/// 2. We loop over all the subviews.
///     1. If the subview doesn’t fit on the current line, we start a new line by
///     resetting the current position’s x component to zero and incrementing
///     the y component by the height of the current line plus spacing.
///     2. We use the current position as the origin for this subview’s rectangle.
///     3. We increase the current position’s x component by the width of the
///     subview and add spacing.
/// The book doesn't go into details about the implementation. It is better to
/// check the WWDC tutorials.
///
/// ### Limitations
///
/// We can’t communicate directly with the subviews: for example, we can’t
/// apply any modifiers, read out preferences, or perform other tasks that require
/// the `View` protocol. All subviews are placed — we can’t remove or add to
/// the list of subviews. For example, we can’t insert decorative views such as
/// separators, nor can we apply a filter to skip certain subviews.
struct LayoutProtocolContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - Previews

#Preview {
    LayoutProtocolContentView()
}
