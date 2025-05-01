//
//  InstafilterLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 01.05.25.
//

import SwiftUI

struct InstafilterLearningsContentView: View {
    @State private var blurAmount = 0.0 {
        didSet {
            // This doesn't work with the slider
            // but it works with the button
            // because it is actually a property wrapper.
            // The slider directly changes the binding value.
            print("Blur amount changed to \(blurAmount)")
        }
    }

    var body: some View {
        VStack {
            Text("Hello, world!")
                .font(.largeTitle)
                .blur(radius: blurAmount)

            Slider(value: $blurAmount, in: 0...20)
                // Instead, we should use `onChange` modifier.
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("Blur amount changed from \(oldValue) to \(newValue)")
                }

            Button("Random blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
    }
}

private struct ConfirmationDialogContentView: View {
    @State private var showingConfirmationDialog = false
    @State private var backgroundColor = Color.white

    var body: some View {
        Button("Hello, World!") {
            showingConfirmationDialog = true
        }
        .frame(width: 300, height: 300)
        .background(backgroundColor)
        .confirmationDialog("Change background", isPresented: $showingConfirmationDialog) {
            Button("Red") { backgroundColor = .red }
            Button("Green") { backgroundColor = .green }
            Button("Blue") { backgroundColor = .blue }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Select a new color")
        }
    }
}

// MARK: - Text Transition Animation

private struct TextTransitionContentView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("\(count)")
                .foregroundColor(.red)
                .font(.largeTitle)
                .contentTransition(.numericText())
            Button("Change") {
                withAnimation(Animation.easeInOut(duration: 3.0)) {
                    count = Int.random(in: 0...100)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    InstafilterLearningsContentView()
}

#Preview("Confirmation Dialog") {
    ConfirmationDialogContentView()
}

#Preview("Text Transition") {
    TextTransitionContentView()
}
