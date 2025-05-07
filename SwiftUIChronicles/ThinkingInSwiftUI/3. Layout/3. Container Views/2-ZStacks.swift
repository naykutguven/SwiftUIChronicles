//
//  ZStacks.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 10.04.25.
//

import SwiftUI

/// At first, ZStack seems like background or overlay modifier. But it is not.
/// ZStack, uses the union of the subviews’ frames  to compute its size.
///
/// If we implemented the badge example from the overlay/background section
/// using a `ZStack` instead of an `overlay`, the badge would influence the
/// layout of the view it’s applied to, because the size of the `ZStack` would
/// include the badge.
struct ZStackContentView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Text("Hello, World!Hello, World!")
                .badgeOverlay {
                    Text("A tall badgeA tall badgeA tall badgeA tall badgeA tall badge").font(.caption)
                }
            Text("Hello, World!")
                .badgeZStack {
                    Text("A tall badgeA tall badgeA tall badge").font(.caption)
                }
        }
        .border(.red)
    }
}

private extension View {
    func badgeOverlay<Badge: View>(@ViewBuilder contents: () -> Badge) -> some View {
        self.overlay(alignment: .topTrailing) {
            contents()
                .padding(3)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.cyan).opacity(0.5)
                )
        }
    }

    func badgeZStack<Badge: View>(@ViewBuilder contents: () -> Badge) -> some View {
        ZStack(alignment: .topTrailing) {
            self
            contents()
                .padding(3)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.cyan).opacity(0.5)
                )
                .fixedSize()
        }
    }
}

// MARK: - Previews

#Preview {
    ZStackContentView()
}
