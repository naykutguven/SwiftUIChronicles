//
//  MoonshotLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 25.04.25.
//

import SwiftUI

struct MoonshotLearningsContentView: View {
    var body: some View {
        ZStack {
            Rectangle().fill(Color.indigo.gradient)
                .ignoresSafeArea()
            Image(systemName: "moon.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.yellow)
                // containerRelativeFrame can be pretty handy when we want to
                // calculate the size of the view relative to its container.
                .containerRelativeFrame(.horizontal) { length, axis in
                    length * 0.8
                }
        }
    }
}

private struct HWSScrollViewContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(0..<100) { index in
                    Text("Item \(index)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct HWSLazyGridContentView: View {
    let layout = [
        GridItem(.adaptive(minimum: 80))
//        GridItem(.fixed(100))
//        GridItem(.adaptive(minimum: 80, maximum: 200))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(0..<100) { index in
                    Text("Item \(index)")
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    MoonshotLearningsContentView()
}

#Preview {
    HWSScrollViewContentView()
}

#Preview {
    HWSLazyGridContentView()
}
