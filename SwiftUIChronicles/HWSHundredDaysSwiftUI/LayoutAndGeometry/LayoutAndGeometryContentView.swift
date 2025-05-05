//
//  LayoutAndGeometryContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 05.05.25.
//

import SwiftUI

/// This view is as big as its content.
///
/// Most of the  content explained in HWS Day 92 is already studied in Thinking in SwiftUI.
struct LayoutAndGeometryContentView: View {
    var body: some View {
        HStack(alignment: .midAccountAndName) {
            VStack {
                Text("@twostraws")
                    .alignmentGuide(.midAccountAndName) { dim in
                        dim[VerticalAlignment.center]
                    }
                Image(.aldrin)
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            VStack {
                Text("Full name:")
                Text("PAUL HUDSON")
                    .alignmentGuide(.midAccountAndName) { dim in
                        dim[VerticalAlignment.center]
                    }
                    .font(.largeTitle)
            }
        }
    }
}

// MARK: - Custom Alignment Guide

private extension VerticalAlignment {
    enum MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }

    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

// MARK: - Modifier Order Example

private struct ModifierOrderContentView: View {
    var body: some View {
        // This is a good example of how modifier order matters.
        // offset modifier does not change the geometry of the view.
        // Its original position is still the same - as we see with the black border.
        // But the offset modifier changes the offset of the view it applies to.
        // That is why the red background is also moved in the second example but
        // the border stays the same.
        Text("Hello, world!")
            .offset(x: 100, y: 100)
            .background(.red)
            .border(.black, width: 2)

        Divider()
            .background(.black)

        Text("Hello, world!")
            .background(.red)
            .offset(x: 100, y: 100)
            .border(.black, width: 2)

        Divider()
            .background(.black)

        Text("Hello, world!")
            .background(.red)
            .border(.black, width: 2)
            .offset(x: 100, y: 100)
    }
}

// MARK: - Previews

#Preview {
    LayoutAndGeometryContentView()
}

#Preview("Modifier Order") {
    ModifierOrderContentView()
}
