//
//  ModifyingAlignmentGuides.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 11.04.25.
//

import SwiftUI

/// We can align views using the same alignment for each view if we are using
/// the built-in alignment guides, e.g. `bottomTrailing` to `bottomTrailing` or
/// `leading` to `leading` and so on. However, we can also modify/override built-in
/// (implicit) alignment guides by providing an explicit alignment guide for a certain
/// alignment or create our own.
///
/// In the example below, we are overriding the default `firstTextBaseline`
/// alignment guide of the `Image` view by giving it an explicit alignment guide.
///
/// By itself, providing an explicit alignment guide doesn’t do anything. Only
/// when this alignment guide is used for placement will this have an eﬀect.
///
/// If we change the stack alignment to `.center`, the custom alignment guide
/// isn't used so it doesn’t aﬀect the alignment of the stack.
struct ModifyingAlignmentGuidesContentView: View {
    let image: some View = Image(systemName: "dog.fill")
        .alignmentGuide(.firstTextBaseline, computeValue: { dimension in
            dimension.height / 2
        })

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            image
            Text("Doggo")
        }

        HStack(alignment: .center) {
            image
            Text("Doggo center")
        }

        Text("Doggo")
            .frame(width: 100, height: 100)
            .background(.red)
            .badge {
                Circle()
                    .fill(.blue)
                    .frame(width: 20, height: 20)
            }

        Text("Doggo")
            .frame(width: 100, height: 100)
            .border(.red)
            .badge {
                Image(systemName: "dog.fill")
                    .foregroundStyle(.brown)
                    .frame(width: 20, height: 20)
            }
    }
}

/// Modifying alignment guides is useful when we want to modify two alignment
/// guides as well.
/// >Important: Note that the alignment guide used for `overlay` which is
/// `topTrailing` matches the modified alignment guides `top` and `trailing`.
private extension View {
    func badge<V: View>(@ViewBuilder _ badge: () -> V) -> some View {
        overlay(alignment: .topTrailing) {
            badge()
                .alignmentGuide(.top) { $0.height / 2 }
                .alignmentGuide(.trailing) { $0.width / 2 }
        }
    }
}

// MARK: - Previews

#Preview {
    ModifyingAlignmentGuidesContentView()
}
