//
//  Colors.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 08.04.25.
//

import SwiftUI

/// If we are using a color directly as a view,, it behaves just like `Rectangle.fill()`.
/// However, if we use it for a background that touches  the non-safe area,
/// it will magically (???)  "bleed" into the non-safe area.
struct ColorsContentView: View {
    var body: some View {
        Color.red
        Color.orange.ignoresSafeArea()
    }
}

// MARK: - Previews

#Preview {
    ColorsContentView()
}
