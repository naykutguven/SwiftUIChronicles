//
//  AspectRatio.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 09.04.25.
//

import SwiftUI

/// This modifier is useful when working with comepletely flexible views.
///
/// In the first example, `Color.red` is completely flexible and can take any size.
/// The `aspectRatio` modifier will compute a rectangle with an aspect ratio of 1.5
/// that fits into the proposed size and then propose that to its subview.
///
/// To be more concrete, the `aspectRatio` modifier is proposed a size of 100 x 200.
/// It will compute a rectangle with an aspect ratio of 1.5 that fits into the
/// proposed size, that is 100 x 66.67, and then propose that to its subview.
/// The subview will accept it and  the `aspectRatio` modifier will report back the size
/// as its own size.
///
/// To the parent view, it always reports the size of its subview, regardless of
/// the proposed size or the specified aspect ratio.
///
/// This means if the subview isn't flexible, the parent view will not be able to
/// propose a size that is different from the subview's size. The parent view
/// will always report the size of its subview.
///
/// In the second example. `Image` is flexible thanks to the `resizable` modifier.
/// Since we don't specify an aspect ratio, it will take the aspect ratio of the image
/// by probing a size of `nil x nil` first. Step by step:
/// 1. The `aspectRatio` modifier is prposed a size of 100 x 200.
/// 2. It will propose `nil x nil` to the image.
/// 3. The image will report its size as 10 x 10, meaning its aspect ratio is 1.0.
/// 4. The `aspectRatio` will then propose a size of 100 x 100.
/// 5. The image will accept this size and report it back.
/// 6. The `aspectRatio` will report the size of 100 x 100 back to its parent view.
struct AspectRatioContentView: View {
    var body: some View {
        Color.red
            .aspectRatio(1.5, contentMode: .fit)
            .frame(width: 100, height: 200)
            .border(.blue)
        Image(systemName: "sun.max.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 200)
            .foregroundStyle(.orange)
            .border(.blue)
    }
}

#Preview {
    AspectRatioContentView()
}
