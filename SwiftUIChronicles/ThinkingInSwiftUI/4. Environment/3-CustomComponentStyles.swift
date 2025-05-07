//
//  CustomComponentStyles.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 13.04.25.
//

import SwiftUI


/// We can use the environment mechanism to create custom component styles –
/// similar to how SwiftUI’s button can be styled with the `.buttonStyle` modifier.
///
/// Eventually, we want to use our custom component style like this:
/// ```swift
/// someView
///     .badgeStyle(.custom)
/// ```
/// So, all the badges inside `someView` will be styled with our custom badge style.
///
/// We need to:
/// 1. Create a protocol BadgeStyle that defines the interface for a badge style.
/// 2. Create an environment key for the badge style.
/// 3. Use the custom badge style within the badge modifier.
///
/// Let's dive in.
///
/// - SeeAlso: [This article](https://movingparts.io/styling-components-in-swiftui) is
/// definitely wortth checking out if you want to learn another way a bit better
/// or different, [this one](https://movingparts.io/composable-styles-in-swiftui)
/// is also worth reading for more advanced stuff.
struct CustomComponentStylesContentView: View {
    var body: some View {
        VStack(spacing: 100) {
            Text("Hello, World!")
                .badgeComponent {
                    Text("1000")
                }

            Text("Hello, World!")
                .badgeComponent {
                    Text("1000")
                }
                .badgeStyle(.fancy)
        }
    }
}

// MARK: - 1. BadgeStyle Protocol

/// The protocol for our badge style is similar to the `ViewModifier` protocol:
/// it requires a single `body` method that wraps an existing view in a badge.
/// We only want this style to be responsible for applying some sort of badge
/// chrome to the label — it doesn’t need to concern itself with positioning the
/// badge relative to the view, as that will be done in the badge modifier. Note
/// that the `makeBody` method takes an `AnyView`, since we need a concrete
/// view type here to make this code  compile.
protocol BadgeStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(_ label: AnyView) -> Body
}

// MARK: - Default Badge Style

struct DefaultBadgeStyle: BadgeStyle {
    var color: Color = .red

    func makeBody(_ label: AnyView) -> some View {
        label
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background {
                Capsule(style: .continuous)
                    .fill(color)
            }
    }
}

// MARK: - 2. BadgeStyleKey

enum BadgeStyleKey: EnvironmentKey {
    static let defaultValue: any BadgeStyle = DefaultBadgeStyle()
}

extension EnvironmentValues {
    var badgeStyle: any BadgeStyle {
        get { self[BadgeStyleKey.self] }
        set { self[BadgeStyleKey.self] = newValue }
    }
}

// MARK: - An extension to use it more conveniently

extension View {
    func badgeStyle(_ style: any BadgeStyle) -> some View {
        environment(\.badgeStyle, style)
    }
}


// MARK: - 3. Use the custom badge style in a badge modifier

private struct OverlayBadge<BadgeLabel: View>: ViewModifier {
    var alignment: Alignment = .topTrailing
    var label: BadgeLabel
    @Environment(\.badgeStyle) private var badgeStyle

    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                AnyView(badgeStyle.makeBody(AnyView(label)))
                    .fixedSize()
                    .alignmentGuide(alignment.horizontal) { $0[HorizontalAlignment.center] }
                    .alignmentGuide(alignment.vertical) { $0[VerticalAlignment.center] }
            }
    }
}

// MARK: - Helper modifier extension

extension View {
    func badgeComponent<V: View>(
        alignment: Alignment = .topTrailing,
        @ViewBuilder _ content: () -> V
    ) -> some View {
        modifier(OverlayBadge(alignment: alignment, label: content()))
    }
}

// MARK: - 4. Let's make another style

private struct FancyBadgeStyle: BadgeStyle {
    var background: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.red)
                .overlay {
                    ContainerRelativeShape()
                        .fill(LinearGradient(colors: [.white, .clear],
                                             startPoint: .top, endPoint: .center))
                }
            ContainerRelativeShape()
                .strokeBorder(Color.white, lineWidth: 2)
                .shadow(radius: 2)
        }
    }

    func makeBody(_ label: AnyView) -> some View {
        label
            .foregroundColor(.white)
            .font(.caption)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(background)
            .containerShape(Capsule(style: .continuous))
    }
}

// MARK: - More convenience won't hurt

extension BadgeStyle where Self == FancyBadgeStyle {
    static var fancy: Self { FancyBadgeStyle() }
}

// MARK: - Previews

#Preview {
    CustomComponentStylesContentView()
}
