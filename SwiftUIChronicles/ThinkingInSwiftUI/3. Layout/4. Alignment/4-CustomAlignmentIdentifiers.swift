//
//  CustomAlignmentIdentifiers.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 11.04.25.
//

import SwiftUI

/// Custom alignments can propagate up through multiple container views and
/// this is what we exactly need here.
///
/// >Important: When the `VStack` now asks its subviews for the `.menu` alignment
/// guide, the `HStack`s will consult their subviews for an explicit alignment
/// guide value before falling back to the default value. This means that the
/// `HStack` will return the explicit alignment guide we specified on the
/// `CircleButton` when asked for its `.menu` alignment guide. In other words,
/// even though we use the default values for our explicit alignment guide, the
/// subview’s explicit alignment guide is used instead of the stack’s implicit
/// alignment guide.
struct CustomAlignmentIdentifiersContentView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Inbox")
                CircleButton(symbol: "tray.and.arrow.down")
                    .frame(width: 30, height: 30)
            }
            HStack {
                Text("Sent")
                CircleButton(symbol: "tray.and.arrow.up")
                    .frame(width: 30, height: 30)
            }
            CircleButton(symbol: "line.3.horizontal")
                .frame(width: 40, height: 40)
        }

        VStack(alignment: .menu) {
            HStack {
                Text("Inbox")
                CircleButton(symbol: "tray.and.arrow.down")
                    .frame(width: 30, height: 30)
                    .alignmentGuide(.menu) { $0.width / 2 }
            }
            HStack {
                Text("Sent")
                CircleButton(symbol: "tray.and.arrow.up")
                    .frame(width: 30, height: 30)
                    .alignmentGuide(.menu) { $0.width / 2 }
            }
            CircleButton(symbol: "line.3.horizontal")
                .frame(width: 40, height: 40)

        }
    }
}

private struct MenuAlignment: AlignmentID {
    // the only requirement is to implement this method
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.width / 2
    }
}

private extension HorizontalAlignment {
    static let menu = HorizontalAlignment(MenuAlignment.self)
}

private struct CircleButton: View {
    let symbol: String

    var body: some View {
        Button {} label: {
            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .padding(10)
                .background(Circle().fill(.primary))
        }
    }
}


// MARK: - Previews

#Preview {
    CustomAlignmentIdentifiersContentView()
}
