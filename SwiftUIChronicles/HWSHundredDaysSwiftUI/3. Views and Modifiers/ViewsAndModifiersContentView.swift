//
//  ViewsAndModifiersContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 19.03.25.
//

import SwiftUI

struct ViewsAndModifiersContentView: View {
    @State private var useRedText = false

    var body: some View {
        Spacer()
        // This is less efficient than using a ternary operator.
        if useRedText {
            Button("Hello, World!") {
                useRedText.toggle()
            }
            .foregroundStyle(.red)
        } else {
            Button("Hello, World!") {
                useRedText.toggle()
            }
            .foregroundStyle(.blue)
        }

        Spacer()

        // This is more efficient than using an if-else statement. Use ternary operators if possible.
        Button("Hello, World!") {
            useRedText.toggle()
        }
        .foregroundStyle(useRedText ? .red : .blue)

        // IMPORTANT: When we click on the second button, the button in the
        // render tree is not removed and reinserted. It "stays" there and the
        // foreground style is updated smoothly, whereas the first button looks
        // like it disappears for a moment and comes back with the updated foreground
        // style when it is clicked. This is because the old button is removed
        // from the render tree and the new one is inserted. So, using ternary
        // operator is more efficient than using an if-else statement and offers
        // much better transitions.
        Spacer()
    }
}

// MARK: - Environment Modifiers and Regular Modifiers

struct EnvironmentModifiersContentView: View {
    var body: some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title) // font modifier is an environment modifier. it can be
        // overridden by individual modifiers

        VStack {
            Text("Gryffindor")
                .blur(radius: 0)
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .blur(radius: 5) // blur() is a regular modifier, so any blurs applied
        // to child views are added to the VStack blur rather than replacing it.
    }
}

// MARK: Custom Modifiers

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }

    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct CustomModifiersContentView: View {
    var body: some View {
        Text("Hello, World!")
            .titleStyle() // better than using .modifier(Title()) directly
            .watermarked(with: "SwiftUI")
    }
}

// MARK: - Previews

#Preview {
    ViewsAndModifiersContentView()
}

#Preview {
    EnvironmentModifiersContentView()
}

#Preview {
    CustomModifiersContentView()
}
