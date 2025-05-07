//
//  ScrollViews.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 10.04.25.
//

import SwiftUI

/// We need to distinguish between the layout behavior of the scroll view itself
/// and that of its content.
///
/// The scroll view itself accepts the proposed size along the scroll axis and it
/// becomes the size of its content along the other axis. For instance, if we
/// use a vertical scroll view as our root view, it will accept the proposed
/// height and it will become the width of its content. See the first and the
/// second scroll views.
///
/// `ScrollView` proposes `nil` along the scroll axis (or axes) and the unmodified
/// proposed size for the other axis.
///
/// >Important: By default, when we specify multiple views for the contents of
/// the scroll view (see the first example)), these subviews are placed inside
/// an implicit `VStack`, regardless of the scroll direction.
///
/// To fix the issue in the second example that the scroll view's width can be
/// narrower than the proposed width, we can use the `frame(maxWidth: .infinity)`
/// modifier.
struct ScrollViewsContentView: View {
    var body: some View {
        ScrollView(.horizontal) {
            Image(systemName: "sun.max.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.orange)
                .border(.blue)
            Text("Hello, World!")
                .border(.black)
        }
        .border(.red)

        ScrollView {
            Image(systemName: "sun.max.fill")
                .foregroundStyle(.orange)
                .border(.blue)
            Text("Hello, World!")
                .border(.black)
        }
        .border(.red)

        ScrollView {
            Text("Hello, World!")
                .border(.black)
                .frame(maxWidth: .infinity)
        }
        .border(.red)
    }
}

#Preview {
    ScrollViewsContentView()
}
