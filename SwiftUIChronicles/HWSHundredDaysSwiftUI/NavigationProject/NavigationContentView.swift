//
//  NavigationContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 27.04.25.
//

import SwiftUI

struct NavigationContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Tap Me") {
                // Here is the problem with using simple NavigationLink
                // The initializer of `DetailView` is already called before
                // tapping the link. Imagine doing this in a list with 1000 items.
                DetailView(number: 556)
            }

            // In this approach, the initializer of `DetailView` is not called
            // until the link is tapped. This is the recommended way to
            // use NavigationLink in a list.
            // We simply attach a Hashable value to the link and use
            // `navigationDestination` to create the destination view.
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
                DetailView(number: selection)
            }
        }
    }
}

private struct DetailView: View {
    var number: Int

    var body: some View {
        Text("Detail View \(number)")
    }

    init(number: Int) {
        self.number = number
        print("Creating detail view \(number)")
    }
}

#Preview {
    NavigationContentView()
}
