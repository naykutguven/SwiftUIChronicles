//
//  LazyVGridHGrid.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 10.04.25.
//

import SwiftUI

/// `LazyVGrid` (and horizontal version too) has a very complex layout algorithm.
///
/// 1. First, it calculates the widths of the columns based on the proposed width.
/// There are three column types: fixed, flexible and adaptive. Fixed-width columns
/// unconditionally become their specified width, flexible columns are flexible
/// (but have lower and upper bounds on their width), and adaptive columns
/// are really containers that host multiple subcolumns
///
/// 2. The grid starts by subtracting all the fixed-column widths and spacings
/// from the proposed width. For the remaining columns, the algorithm proposes
/// the remaining width, divided by the number of remaining columns, in order
/// of the columns. Flexible columns clamp this proposal using their bounds
/// (minimum and/or maximum width).
/// Adaptive columns are special though: the grid tries to fit as many subcolumns
/// inside an adaptive column as possible by taking the proposed column width
/// and dividing it by the minimum width specified for the adaptive column.
/// These subcolumns can then be stretched out to the specified maximum width
/// to fill the remaining space.
///
/// 3. Now that the column widths have been computed, the grid computes its own
/// width as the sum of the column widths, plus any spacing in between columns.
/// For its height, the grid proposes `columnWidth ⨉ nil` to its subviews
/// to compute the row heights and then computes its own height as the sum
/// of the row heights plus spacing.
///
/// >Important: Contrary to `HStack` and `VStack`, grids go through the column
/// layout algorithm twice: once during the layout pass, and then again during
/// the render pass. During layout, the grid starts out with its proposed width.
/// However, during the render pass, it starts out with the width that was
/// calculated during the layout pass, and it divides that width among the columns
/// again. This can have really surprising results. For example, consider the grid below:
///
/// We start at a remaining width of 200 points, minus 10 points of spacing, which
/// gives us 190 points. For the first column, we calculate the width as 190 / 2
/// remaining columns, which equals 95 points. Since the first column has a minimum
/// width of 60 points, the width of 95 points isn’t aﬀected by the clamping,
/// so the remaining width stands at 95 points. The second column becomes 95
/// points clamped to its minimum of 120 points, i.e. 120 points wide.
///
/// However, that’s not what we see in the rendering of this grid: the first
/// column renders 108 points wide, and the second one renders 120 points wide,
/// whereas we calculated 95 points and 120 points. That’s where the second
/// layout pass comes in.
///
/// The overall width of the grid as calculated by the first pass is
/// 95 + 10 + 120 = 225 points. The fixed frame with a width of 200 points
/// around the grid centers the grid, shifting it (225 − 200) / 2 = 12.5 points
/// to the left. When it’s time for the grid to render itself, it goes through the
/// column layout again, but this time starting out with a remaining width of
/// 225 points.
///
/// The second pass starts with 225 points minus 10 points spacing, or 215 points.
/// The first column becomes 215 points divided by 2 remaining columns, equaling
/// 108 points (rounded). The remaining width is now 215 minus 108, giving us
/// 107 points. The second column becomes 107 points clamped to its minimum of
/// 120 points. This is exactly what we see in the example below.
///
/// In addition to the surprising column widths, we can now also explain why
/// the grid renders oﬀ-center in the fixed frame: since the frame around the
/// grid has calculated the grid’s origin based on the original width of 225
/// points, but the grid now renders itself with an overall width of
/// 108 + 10 + 120 = 238 points, the grid appears out of center by about 7 points.
struct LazyVGridHGrid: View {
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 60)),
                GridItem(.flexible(minimum: 120))
            ],
            spacing: 10,
            content: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red.opacity(0.2))
                    .background(GeometryReader { proxy in
                        Text("Red \(proxy.size.width.formatted())")
                    })
                    .frame(height: 100)

                RoundedRectangle(cornerRadius: 10)
                    .fill(.green.opacity(0.2))
                    .background(GeometryReader { proxy in
                        Text("Red \(proxy.size.width.formatted())")
                    })
                    .frame(height: 100)

            }
        )
        .frame(width: 200)
        .border(.teal)
    }
}

/// `Grid` is buggy so we are skipping it.

// MARK: - ViewThatFits

/// When we want to display diﬀerent views depending on the proposed size, we
/// can use `ViewThatFits`. It takes a number of subviews, and it displays
/// the first subview that fits. It does so by proposing nil to figure out the
/// ideal size for each subview, and it displays the first subviews (in the order
/// the subviews appear in the code) where the ideal size fits within the
/// proposed size. If none of the subviews fit, it picks the last subview.
extension LazyVGridHGrid {}

// MARK: - Rendering Modifiers

/// Rendering modifiers - for example `scaleEffect`, `rotationEffect`, `offset` -
/// don't influence the layout algorithm, meaning the view is still situated
/// in its original position from the layout system’s perspective.

// MARK: - Previews

#Preview {
    LazyVGridHGrid()
}
