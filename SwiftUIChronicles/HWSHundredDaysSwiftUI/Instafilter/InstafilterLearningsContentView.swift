//
//  InstafilterLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 01.05.25.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
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

// MARK: - CoreImage and SwiftUI

private struct CoreImageContentView: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
                
        }
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        let inputImage = UIImage(resource: .mystery)
        let beginImage = CIImage(image: inputImage)

        let context = CIContext()
        // some of the new API isn't great or very swifty tbh...
        let currentFilter = CIFilter.sepiaTone()

        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1.0

        guard let output = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

// MARK: - "Content Unavailable" view

private struct ContentUnavailableContentView: View {
    var body: some View {
        ContentUnavailableView(
            "No snippets",
            systemImage: "swift",
            description: Text("No snippets available at the moment.")
        )

        // A bit more customization
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
                .foregroundStyle(.red)
        } description: {
            Text("You don't have any saved snippets yet.")
        } actions: {
            Button("Create Snippet") {
                // create a snippet
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Photo picking

private struct PhotoPickerContentView: View {
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()

    var body: some View {
        VStack {
            PhotosPicker(
                "Select a photo",
                selection: $pickerItems,
                maxSelectionCount: 3,
                matching: .images
            )

            // another way to customize the button
//            PhotosPicker(
//                selection: $pickerItems,
//                maxSelectionCount: 3,
//                matching: .any(of: [.images, .not(.screenshots)]),
//            ) {
//                Label("Select a photo", systemImage: "photo")
//            }

            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { index in
                    selectedImages[index]
                        .resizable()
                        .scaledToFit()
                }
            }
            .onChange(of: pickerItems) {
                Task {
                    selectedImages.removeAll()

                    for item in pickerItems {
                        if let loadedImage = try await item.loadTransferable(type: Image.self) {
                            selectedImages.append(loadedImage)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - How to share content

private struct ShareSheetContentView: View {
    var body: some View {
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)

        ShareLink(
            item: URL(string: "https://www.hackingwithswift.com")!,
            subject: Text("Learn Swift here"),
            message: Text("Check out the 100 Days of SwiftUI!")
        )

        ShareLink(
            item: URL(string: "https://www.hackingwithswift.com")!
        ) {
            Label("Spread the word about Swift", systemImage: "swift")
        }

        let example = Image(.UK)

        ShareLink(
            item: example,
            preview: SharePreview("Singapore Airport", image: example)
        ) {
            Label("Click to share", systemImage: "airplane")
                .foregroundStyle(.white)
                .padding()
                .background(.blue)
                .clipShape(.capsule)
        }
    }
}

// MARK: - Ask for an App Store review

private struct AskForReviewContentView: View {
    // This is necessary
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        // This is the simplest way to ask for a review but
        // this isn't ideal because the user might have blocked
        // the review request system wide or the OS has shown
        // many alerts already. It is better to ask for a review
        // when the time is right, e.g., after the user performed a certain
        // number of actions or completed a task.
        Button("Leave a review") {
            requestReview()
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

#Preview("CoreImage and SwiftUI") {
    CoreImageContentView()
}

#Preview("Content Unavailable") {
    ContentUnavailableContentView()
}

#Preview("Photo Picker") {
    PhotoPickerContentView()
}

#Preview("Share Sheet") {
    ShareSheetContentView()
}
