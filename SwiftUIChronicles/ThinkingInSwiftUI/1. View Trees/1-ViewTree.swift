//
//  ViewTree.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 14.03.25.
//

import SwiftUI

struct ViewTree: View {
    var body: some View {
        // Take a look at this view and its view tree. We need to always read
        // from the bottom up to visualize view trees. So, the view tree is like this:
        //              .background
        //               ____|____
        //              /         \
        //          .padding     Color
        //             |
        //           Text
        //
        // Just to make it easier to draw, I will write it like this:
        //
        // .background
        //   |
        //   |_ .padding
        //   |   |_ Text
        //   |
        //   |_ Color
        //
        // The background modifier is at the root of the view tree. Its primary subview
        // is the padded text, and it’s drawn on top. The secondary subview is
        // the blue color, and it’s drawn behind the primary subview. Each time we
        // apply a view modifier like padding or background to the text view,
        // it gets wrapped in another layer.
        Text("Hello, World!")
            .padding()
            .background(Color.blue)

        // The view tree of this view
        //
        // .padding
        //   |
        //   |_ .background
        //       |_ Text
        //       |_ Color
        //
        // Why Color is a sibling view of Text and why the layout differs will be
        // explained in the Layout chapter.
        Text("Hello, World!")
            .background(Color.blue)
            .padding()
    }
}

#Preview {
    ViewTree()
}
