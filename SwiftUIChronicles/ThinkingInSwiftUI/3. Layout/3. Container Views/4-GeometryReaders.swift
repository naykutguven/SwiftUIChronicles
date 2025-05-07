//
//  GeometryReaders.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 10.04.25.
//

import SwiftUI

/// `GeometryReader` is used to access the proposed size. It always accepts the
/// proposed size and reports that to its view builder closure through its `GeometryProxy`.
/// This proxy also allows access to  the current safe area insets and the frame
/// of the view in a specific coordinate space, and it allows us to resolve anchors.
/// > Important: Because a geometry reader always becomes the proposed size,
/// if we want to — for example — measure the width of some `Text` view by
/// putting a geometry reader around it, this will influence the layout around the text.
///
/// There are two ways to use a geometry reader without affecting the layout:
/// 1. When we wrap a completely flexible view inside a `GeometryReader`, it won’t
/// aﬀect the layout. For example, when we have a scroll view, which becomes the
/// proposed size anyway, we can wrap it using a geometry reader to access the
/// proposed size.
///
/// 2. When we put a geometry reader inside a background or overlay modifier, it
/// won’t influence the size of the primary view. Inside the background or overlay,
/// we can then use the proxy to read out diﬀerent values related to the view’s
/// geometry. This is useful to measure the size of a view, as the size of the
/// primary subview will be proposed to the secondary subview (the geometry reader).
struct GeometryReadersContentView: View {
    var body: some View {
        GeometryReader { proxy in
            Text("Size: \(proxy.size.width) x \(proxy.size.height)")
        }

        Text("Hello, World!")
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            print("Hello world text size: \(geometry.size)")
                        }
                }
            )
    }
}

#Preview {
    GeometryReadersContentView()
}
