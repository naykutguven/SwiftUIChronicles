//
//  Images.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 08.04.25.
//

import SwiftUI

/// `Image` views report a static size (the size of the image) by default. When we
/// call `resizable` modifier, they become completely flexible and can take any
/// size. If we call `aspectRatio` modifier, they will try to fit into the
/// proposed size while keeping the aspect ratio, which is usually done in practice.
struct ImagesContentView: View {
    var body: some View {
        Image(systemName: "sun.max.fill")
            .foregroundStyle(.orange)
        Image(systemName: "moon.fill")
            .resizable()
            .foregroundStyle(.yellow)
        Image(systemName: "cloud.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.blue)
    }
}

// MARK: - Previews

#Preview {
    ImagesContentView()
}
