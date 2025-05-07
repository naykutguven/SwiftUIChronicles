//
//  Texts.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 07.04.25.
//

import SwiftUI

/// `Text` view fits itself into the proposed size by default. It uses
/// these methods in the order they are listed to fit itself:
/// 1. word wrapping - break the text into multiple lines
/// 2. line wrapping - break up words
/// 3. truncation
/// 4. clipping the text
///
/// The text view always reports back the exact size it needs to render its content,
/// that is, less than or equal to the proposed width and at least one line high -
/// except for proposing 0 x 0.
///
/// There are diferent methods to change how the size is calculated such as
/// lineLimit, truncationMode, and frame modifiers.
///
/// If we call `fixedSize()` on a text view, it will be propsed `nil x nil`
/// and become its ideal size.
///
/// >Important: In the example below, the text view renders outside
/// the bounds of its parent view. This is a great example of how a parent view
/// in SwiftUI cannot expect its subview to respect the proposed size — the subview
/// has the final say in determining its own size.
struct TextContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .fixedSize()
                .padding()
                .background(Color.orange)
        }
        .frame(width: 20, height: 200)
        .border(.blue)
    }
}

// MARK: - Previews

#Preview {
    TextContentView()
}
