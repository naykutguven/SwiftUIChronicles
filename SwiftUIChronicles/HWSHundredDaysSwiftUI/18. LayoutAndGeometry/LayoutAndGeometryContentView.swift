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

// MARK: - GeometryReader

private struct GeometryReaderExamplesContentView: View {
    var body: some View {
        GeometryReader { proxy in
            Image(.kevinHorstmann141705)
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width * 0.8)
            // We could use containerRelativeFrame for some purposes but
            // it is not always what we want. GeometryReader is more flexible.
        }

        // Check out the example below.
        //
        // containerRelativeFrame looks at the nearest container which is not
        // the HStack... but the whole screen. BUT its alignment is still in HStack
        HStack {
            Text("IMPORTANT")
                .frame(width: 200)
                .background(.blue)

            Image(.kevinHorstmann141705)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, _ in
                    size * 0.8
                }
        }

        // If we use GeometryReader instead, it will take the size that is
        // proposed to it into account. THe default alignment inside the GeometryReader
        // is the top left corner. We can solve this by adding another frame modifier.
        HStack {
            Text("IMPORTANT")
                .frame(width: 200)
                .background(.blue)

            GeometryReader { proxy in
                Image(.kevinHorstmann141705)
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width * 0.8)
                    // Centers the content inside the GeometryReader
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}

private struct GeometryReaderSecondExampleContentView: View {
    var body: some View {
        VStack {
            // takes up all of the proposed space. It is a preferred size, not an absolute size.
            GeometryReader { proxy in
                Text("Hello, world!")
                    .frame(width: proxy.size.width * 0.8)
                    .background(.red)
            }
            .background(.green)

            Text("More text")
                .background(.blue)
        }
    }
}

// MARK: - Some ScrollView effects using GeometryReader

private struct ScrollViewWithGeometryReaderContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullViewProxy in
            ScrollView {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % colors.count])
                            // Creates a spinning helix effect
                            .rotation3DEffect(
                                .degrees(proxy.frame(in: .global).minY - fullViewProxy.size.height / 2) / 5,
                                axis: (x: 0, y: 1.0, z: 0)
                            )
                    }
                    .frame(height: 40)
                }
            }
        }

        // Cover flow effect
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    GeometryReader { proxy in
                        Text("Number \(num)")
                            .font(.largeTitle)
                            .padding()
                            .background(.red)
                            .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                            .frame(width: 200, height: 200)
                    }
                    .frame(width: 200, height: 200)
                }
            }
        }
    }
}

// MARK: - Much easier ways to achieve neat scroll effects

private struct EasyScrollViewEffectsContentView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { num in
                    Text("Number \(num)")
                        .font(.largeTitle)
                        .padding()
                        .background(.red)
                        .frame(width: 200, height: 200)
                        // So much easier
                        .visualEffect { content, proxy in
                            content
                                .rotation3DEffect(
                                    .degrees(-proxy.frame(in: .global).minX) / 8,
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        }
                }
            }
            // Making each view inside the HStack a scroll target
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

// MARK: - Previews

#Preview {
    LayoutAndGeometryContentView()
}

#Preview("Modifier Order") {
    ModifierOrderContentView()
}

#Preview("Geometry Reader") {
    GeometryReaderExamplesContentView()
}

#Preview("Geometry Reader 2nd example") {
    GeometryReaderSecondExampleContentView()
}

#Preview("ScrollView effects with GeometryReader") {
    ScrollViewWithGeometryReaderContentView()
}

#Preview("Easy ScrollView effects") {
    EasyScrollViewEffectsContentView()
}
