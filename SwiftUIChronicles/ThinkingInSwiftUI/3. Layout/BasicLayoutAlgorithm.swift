//
//  BasicLayoutAlgorithm.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.04.25.
//

import SwiftUI

/// SwiftUI's layout algorithm is straightforward: the parent iew proposes
/// a size to its subview, the subview determines its own size based on the
/// proposed size, and the subview reports that size back to its parent view.
/// The parent view then places the subview within its own coordinate system.
///
/// SwiftUI’s layout **algorithm proceeds top-down (recursively) along the view tree.**
/// So, it is crucial to understand how the view tree is structured, as this will
/// help understand how the layout algorithm works.
struct BasicLayoutAlgorithm: View {

    /// In this example, the `VStack` is the root view. So, it receives the
    /// safe area as the proposed size. it will then propose sizes to its subviews
    /// recursively in order to determine its own size. The stack view will
    /// report its size as the union of its subviews' frames (plus spacing, of course)
    /// to the window which is the parent view.
    ///
    /// We can imagine the API used by SwiftUI to be like this:
    /// ```swift
    /// extension View {
    ///     func sizeThatFits(in proposedSize: ProposedViewSize) -> CGSize {
    ///         ..
    ///     }
    /// }
    /// ```
    /// Both `width` and `height` properties of `ProposedViewSize` are optional,
    /// unlike the propoerties of `CGSize`. Proposing a size of `nil` means
    /// that the view can become its ideal size in that dimension.
    ///
    ///
    /// So, basically the layout algorithm is:
    /// 1. The parent proposes a size to its subview. Note, that this is recursive
    /// so, primary view comes first.
    /// 2. The subview determines its own size based on the proposal,
    /// recursively proposing sizes to its own subviews, if any.
    /// 3. The subview reports its size to the parent.
    /// 4. The parent places the subview.
    var body: some View {
        VStack {
            Image(systemName: "globe")
            Text("Hello, World!")
        }
    }
}

/// In this example, we will assume that the root view is given size of 300x400.
/// Let's go through the layout algorithm step by step:
///
/// 1.The root view (background) proposes a size of 300x400 to its primary subview (padding).
/// 2. The padding view proposes a size of 260x360 to its primary subview (text) after
/// subtracting the padding amount on each side.
/// 3. The text view calculates its own size as, let's say, 75x20 based on its content.
/// Reports it back to the padding view.
/// 4. The padding view calculates its own size as 115x60 after adding the padding
/// amount on each side. It reports this size back to the background view.
/// 5. The background view proposes this size to the Color view.
/// 6. The Color view accepts it and reports back the same size.
/// 7. The background view reports its size as 115x60 to the window.
///
/// >Tip: We can use border color to visualize the view tree and understand how
/// views are laid out.
struct BasicLayoutAlgorithmExampleTwo: View {
    /// The view tree:
    /// background
    ///  |
    ///  |_ .padding
    ///  |   |_ Text
    ///  |
    ///  |_ Color
    var body: some View {
        Text("Hello, World")
            .padding(20)
            .background(Color.orange)
    }
}

// MARK: - Previews

#Preview {
    BasicLayoutAlgorithm()
}

#Preview("Example Two") {
    BasicLayoutAlgorithmExampleTwo()
}
