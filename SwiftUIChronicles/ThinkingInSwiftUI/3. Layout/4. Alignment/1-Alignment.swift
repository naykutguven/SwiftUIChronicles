//
//  Alignment.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 11.04.25.
//

import SwiftUI

/// Almost all views in SwiftUI center their subviews by default. SwiftUI uses
/// alignments **to position views relative to each other**.
///
/// Assume the size of the text is 50 x 20. The `frame` modifier has an `alignment`
/// parameter with a default value of `.center`. So the text will be centered.
/// This is done in the following steps:
///
/// 1. The frame asks the text for its horizontal center. The text is 50 pts wide,
/// so the center is 25 - in its local coordinate space. This value is called
/// `horizontal center alignment guide`.
///
/// 2. The frame asks the text for its vertical center. The text is 20 pts high,
/// so the center is 10 - in its local coordinate space. This value is called
/// `vertical center alignment guide`.
///
/// 3. The frame computes the center of its own coordinate space. It is 200 x 200, so
/// the center is at (100, 100).
///
/// 4. Now the frame centers the text by taking the difference between these two
/// centers (100 - 25, 100 - 10) and places the origin of the text to (75, 90).
///
/// In the second example, the text is aligned to the bottom trailing corner.
/// We follow the same algorithm, except this time the frame will ask the text for
/// its trailing and bottom alignment guides instead of the center ones.
///
/// 1. The text returns 50 and 20, respectively.
/// 2. The frame computes its own trailing and bottom alignment guides: (200, 200).
/// 3. The frame places the origin of the text at (200 - 50, 200 - 20) = (150, 180).
struct AlignmentContentView: View {
    var body: some View {
        Text("Hello")
            .frame(width: 200, height: 200)
            .background(.yellow)

        Text("Hello")
            .frame(width: 200, height: 200, alignment: .bottomTrailing)
            .background(.orange)
    }
}

// MARK: - Previews

#Preview {
    AlignmentContentView()
}
