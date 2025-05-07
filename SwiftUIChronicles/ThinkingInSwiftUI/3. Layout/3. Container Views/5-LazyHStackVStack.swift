//
//  LazyHStackVStack.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 10.04.25.
//

import SwiftUI


/// Lazy stacks share the layout behavior of their non-lazy counterparts in a way
/// that they have the size of the union of their subviews. However, they
/// don't try to distribute the available size among their subviews. Instead,
/// they just propose `nil x proposedHeight` (or `proposedWidth x nil`) to their
/// subviews,which means that their subviews become their ideal width (or height).
struct LazyHStackVStackContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<100) { i in
                    Text("View \(i)")
                        .padding(.vertical)
                        .border(.blue)
                        .onAppear {
                            print("View \(i) appeared")
                        }
                }
            }
            .border(.red)
        }
    }
}

#Preview {
    LazyHStackVStackContentView()
}
