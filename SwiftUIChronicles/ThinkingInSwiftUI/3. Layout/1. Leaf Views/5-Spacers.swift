//
//  Spacers.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 08.04.25.
//

import SwiftUI

/// `Spacer` views accept any proposed size when they are not in a stack view.
/// However, when they are in a stack view, their behavior changes. In a vertical
/// stack, it  accepts any height from its minimum height to infinity but
/// reports zero width. In a horizontal stack, it is the same, just the other way
/// around. The minimum length of the `Spacer` is the length of the default padding,
/// unless specified in its initializer.
struct SpacerContentView: View {
    /// Instead of using a `Spacer`, it is recommended to use a flexible frame
    /// modifier with alignment. The reason is that the `Spacer` has a default
    /// minimum length. Thus, the text might start wrapping or truncating sooner
    /// than necessary, because the `Spacer` also occupies some of the proposed
    /// width of the HStack.
    var body: some View {
        HStack {
            Spacer()
            Text("Hello, World!")
        }

        Text("Hello, World!")
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - Previews

#Preview {
    SpacerContentView()
}
