//
//  GeometryReaders.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 18.04.25.
//

import SwiftUI

/// We can replicate almost all of the behavior of the `Layout` Protocol (and
/// more) using preferences, geometry readers, and ZStack.
///
/// `GemotryReader` is a view with many useful features:
/// - It  unconditionally accepts the proposed size.
/// - It reports that size via a  `GeometryProxy` to its view builder closure.
/// - Using this proxy, we can:
///     -  Access the size of the geometry reader (as a `CGSize` — this is the
///     proposed size, with nil replaced by the default value of 10 points).
///     - Read the safe area insets
///     - Read the frame (in a specific coordinate space)
///     - Resolve  anchors.
///
/// - Important: When using a geometry reader to measure the size of a view,
/// we recommend putting it inside an `overlay` or `background`. This was discussed
/// in the `Layout` chapter.
///
/// - Important: If we want to use the size of the view in one of its ancestors,
/// we’re out of luck: since the geometry reader is just another view, we can’t
/// assign a state property inside the view builder closure or modify state otherwise.
/// To overcome this, we can do the third text example.
///
/// - Warning: This workaround is good only for a single view. When we need to
/// measure multiple related views, using `onAppear` and `onChange(of:)` doesn’t
/// scale very well. Instead, we can use preferences.
struct AdvancedGeometryReadersContentView: View {
    var text: String = "Hellosss"
    @State private var overflows: Bool = false

    var body: some View {
        VStack {
            Text("Hello")
                .padding()
                .background(
                    GeometryReader { proxy in
                        let radius: CGFloat = proxy.size.width > 80 ? 10 : 5
                        RoundedRectangle(cornerRadius: radius)
                            .fill(.blue)
                    }
                )

            Text("Hello, world!")
                .padding()
                .background(
                    GeometryReader { proxy in
                        let radius: CGFloat = proxy.size.width > 80 ? 10 : 5
                        RoundedRectangle(cornerRadius: radius)
                            .fill(.blue)
                    }
                )
        }

        Text(text)
            .fixedSize()
            .overlay {
                GeometryReader { proxy in
                    let tooWide = proxy.size.width > 100
                    // Basically, we are adding a view inside the geometry reader's
                    // view builder closure and then using it to access its
                    // `onAppear` `onChange` modifiers in which we can modify
                    // state.
                    Color.clear
                        .onAppear {
                            overflows = tooWide
                        }
                        .onChange(of: tooWide) { _, _ in
                            overflows = tooWide
                        }
                }
            }
            .frame(width: 100)
            .border(overflows ? Color.red : Color.green)
    }
}

// MARK: - Previews

#Preview {
    AdvancedGeometryReadersContentView()
}
