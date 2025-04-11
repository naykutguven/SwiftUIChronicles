//
//  ContainerAlignment.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 11.04.25.
//

import SwiftUI


/// `ZStack` (and all other container views except for `frame`) has to consult
/// all of its subviews for their alignment guides and align them relative to
/// each other.
///
/// `ZStack` first has to compute its own size (based on the sizes of its
/// subviews and their alignment guides) before it can then use the alignment
/// to place the subviews.
///
/// In this example, `ZStack` will align its subviews as follows (the default
/// alignment is `.center`):
///
/// 1. Determine its own size:
///     1. Asks the first subview, the `Rectangle`, for its size and center
///   alignment guides: 50 x 50 and (25, 25)
///     2.Asks the `Text` the same: let's assume 100 x 20 and (50, 10).
///     3. Computes the `Text`'s origin relative to the `Rectangle`'s:
///     (25, 25) - (50, 10) = (-25, 15).
///     4. Determines the frames of the subviews: combination of origin and size.
///     5. Compute the union of the two subview frames, which has an origin of
///     (-25, 0) and a size of 100x50. The size of that rectangle is the
///     `ZStack`’s own size.
///
/// 2. Place the subviews:
///   1. Its own center becomes (50, 25).
///   2. Compute the `Rectangle`'s origin: (50, 25) - (25, 25) = (25, 0).
///   3. Compute the `Text`'s origin: (50, 25) - (50, 10) = (0, 15).
///
/// In general, this is how every container aligns its subviews:
/// 1. Determine its own size:
///     1. Determine the sizes of its subviews. The specifics depend on the
///     particular view type, which we discussed in the first part of this chapter.
///     2. Ask the subviews for their alignment guides for the container’s alignment.
///     3. Compute the origins for the subview’s frames, using any particular
///     subview as a reference.
///     4. Compute the union of the subview’s frames. The size of that rectangle
///     is the container’s size.
/// 2. Place the subviews:
///     1. Compute the alignment guides of the container itself based on its size.
///     2. Compute each subview’s origin by subtracting its alignment guides
///     from the container’s alignment guides.
struct ContainerAlignmentContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.orange)
                .frame(width: 50, height: 50)
            Text("Hello, World!")
        }
    }
}

#Preview {
    ContainerAlignmentContentView()
}
