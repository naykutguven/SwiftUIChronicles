//
//  Preferences.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 18.04.25.
//

import SwiftUI

/// `Preferences` are the counterpart of the environment mechanism in the sense
/// that they propagate calues down the tree as opposed to the environment
/// which propagates values up the tree. In the case of a flow layout, we could
/// measure the size of each subview and propagate it to the container using a
/// preference. In addition, preferences let us define how these values are
/// combined. For example, in the case of a flow layout, we’d like to combine
/// each individual measurement into an array or dictionary of sizes.
///
/// Preferences are defined similar to environment values. The `PreferenceKey`
/// protocol requires a default value (in case no preference was set), and a
/// reduce method. This is used to combine two values.
/// - Tip: For example, if we want to measure the maximum width of multiple
/// views, we could have a CGFloat value and implement reduce by taking the
/// maximum. If we’re interested in a single value that might be at any point
/// in the subtree, we could model it using an optional and take the first non-nil value.
///
/// The values from each `.preference` modifier bubble up the view tree, and the
/// key’s `reduce` method is used to combine values from multiple subviews.
/// Once an `.onPreferenceChange(_ key:perform:)` modifier with the same key is
/// encountered, the `perform` closure is called with the aggregated value from
/// the subtree within the `.onPreferenceChange`. When a state change that aﬀects
/// the preferences happens, this process starts from a blank slate again.
struct PreferencesContentView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0..<5) { ix in
                Text("Item \(ix)" + String(repeating: "\n", count: ix/2))
                    .padding()
                    .measureSize()
            }
        }
        .onPreferenceChange(SizeKey.self) { print($0) }
    }
}

// MARK: - Custom PreferenceKey

struct SizeKey: PreferenceKey {
    static var defaultValue: [CGSize] = []

    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Helper extension from the previous chapter

private extension View {
    func measureSize() -> some View {
        overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizeKey.self, value: [proxy.size])
            }
        }
    }
}

// MARK: Putting it all together

struct ZStackFlowLayoutExample: View {
    @State private var containerWidth: CGFloat?

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let width = proxy.size.width
                Color.clear
                    .onAppear {
                        containerWidth = width
                    }
                    .onChange(of: width) { _, newValue in containerWidth = newValue }
            }
            .frame(height: 0)
            ZStackFlowLayout(containerWidth: containerWidth ?? 0)
            // Become exactly the proposed size
                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

private struct ZStackFlowLayout: View {
    @State private var sizes: [CGSize]? = nil
    var containerWidth: CGFloat
    let subviewCount = 5

    func subview(for index: Int) -> some View {
        Text("Item \(index)" + String(repeating: "\n", count: index / 2))
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(hue: .init(index) / 10, saturation: 0.8, brightness: 0.8))
            }
    }

    var body: some View {
        let offsets = sizes.map {
            layout(sizes: $0, containerWidth: containerWidth).map { $0.origin }
        } ?? Array(repeating: .zero, count: subviewCount)
        ZStack(alignment: .topLeading) {
            ForEach(0..<subviewCount) { ix in
                subview(for: ix)
                    .fixedSize()
                    .measureSize()
                    .alignmentGuide(.leading) { _ in -offsets[ix].x }
                    .alignmentGuide(.top) { _ in -offsets[ix].y }
            }
        }
        .onPreferenceChange(SizeKey.self) { sizes = $0 }
    }

    private func layout(
        sizes: [CGSize],
        spacing: CGSize = .init(width: 10, height: 10),
        containerWidth: CGFloat
    ) -> [CGRect] {
        var result: [CGRect] = []
        var currentPosition: CGPoint = .zero
        func startNewline() {
            if currentPosition.x == 0 { return }
            currentPosition.x = 0
            currentPosition.y = result.max(by: { $0.maxY < $1.maxY })!.maxY + spacing.height
        }
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                startNewline()
            }
            result.append(CGRect(origin: currentPosition, size: size))
            currentPosition.x += size.width + spacing.width
        }
        return result
    }
}
// MARK: - Previews

#Preview {
    PreferencesContentView()
}
