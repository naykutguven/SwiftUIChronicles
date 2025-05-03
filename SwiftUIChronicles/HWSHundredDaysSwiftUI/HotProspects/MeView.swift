//
//  MeView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.05.25.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var email = "you@yoursite.com"

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)

                TextField("Email address", text: $email)
                    .textContentType(.emailAddress)
                    .font(.title)

                Image(uiImage: generateQRCode(from: "\(name)\n\(email)"))
                    // needed to prevent blurriness because the QR code is
                    // generated at a much lower resolution
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .navigationTitle("Your code")
        }
    }

    private func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }

        return UIImage(cgImage: cgImage)
    }
}

#Preview {
    MeView()
}
