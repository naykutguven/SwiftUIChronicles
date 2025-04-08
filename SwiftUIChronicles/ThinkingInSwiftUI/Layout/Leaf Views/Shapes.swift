//
//  Shapes.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 07.04.25.
//

import SwiftUI

/// Most built-in shapes except for `Circle` accepts any proposed size from 0 to
/// infinity and fill the available space. `Circle`, howevert, fits itself into the
/// proposed size and report the actual size of the circle.
///
/// If `nil x nil` is proposed, meaning we call `fixedSize()` on the shape,
/// the shape will be drawn in default size of 10 x 10.
struct ShapesContentView: View {
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.red)
            Circle()
                .foregroundStyle(.yellow)
                .background(Color.orange)
            Ellipse()
                .foregroundStyle(.green)
            Capsule()
                .foregroundStyle(.blue)
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.purple)
            Rectangle()
                .foregroundStyle(.pink)
                .fixedSize()
            BookmarkShape()
                .foregroundStyle(.indigo)
        }
        .padding()
    }
}

// MARK: - BookmarkShape

/// The bookmark shape is a custom shape that draws a path to represent a bookmark.
///
/// Say, we want the bookmark shape to always have an aspect ratio of 1:2. Instead of
/// calling the `aspectRatio` modifier on the shape, we can implement the
/// `sizeThatFits` method of the `Shape` protocol to calculate the size of the
/// shape and return the appropriate size with the desired aspect ratio.
struct BookmarkShape: Shape {
    // MARK: - Shape Protocol Methods

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: rect[.topLeading])
            p.addLines([
                rect[.bottomLeading],
                rect[.init(x: 0.5, y: 0.8)],
                rect[.bottomTrailing],
                rect[.topTrailing],
                rect[.topLeading]
            ])
            p.closeSubpath()
        }
    }

    nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        var result = proposal.replacingUnspecifiedDimensions()
        let aspectRatio: CGFloat = 1 / 2
        
        let widthForProposedHeight =  result.height * aspectRatio

        if result.width >= widthForProposedHeight {
            result.width = widthForProposedHeight
        } else {
            result.height = result.width / aspectRatio
        }

        return result
    }
}

extension CGRect {
    subscript(_ point: UnitPoint) -> CGPoint {
        CGPoint(
            x: point.x * width + minX,
            y: point.y * height + minY
        )
    }
}

// MARK: - Previews

#Preview {
    ShapesContentView()
}

#Preview("BookmarkShape") {
    BookmarkShape()
}
