//
//  CoordinateSpaces.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 18.04.25.
//

import SwiftUI

struct CoordinateSpacesContentView: View {
    var body: some View {
        VStack {
            Text("Hello")
            Text("Second")
                .overlay { GeometryReader { proxy in
                    let _ = print([
                        "Global \(proxy.frame(in: .global))",
                        "local \(proxy.frame(in: .local))",
                        "Stack \(proxy.frame(in: .named("Stack")))"
                    ].joined(separator: "\n"))
                    Color.clear
                }}
        }
        .coordinateSpace(name: "Stack")
    }
}

#Preview {
    CoordinateSpacesContentView()
}
