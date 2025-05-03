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

    // Just to cache the generated QR code
    @State private var qrCode = UIImage()

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

                Image(uiImage: qrCode)
                    // needed to prevent blurriness because the QR code is
                    // generated at a much lower resolution
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                // This needs another permission request in Info.plist:
                // Privacy - Photo Library Additions Usage Description” for the key name
                // - “We want to save your QR code.” as the value.

                    .contextMenu {
                        ShareLink(
                            item: Image(uiImage: qrCode),
                            preview: SharePreview("My QR Code", image: Image(uiImage: qrCode))
                        )
                    }
            }
            .navigationTitle("Your code")
            // This way, we don't call generateQRCode in the view body
            // which would cause a loop since it updates the state
            // property qrCode which then updates the view -> runs the body again.
            .onAppear(perform: updateQRCode)
            .onChange(of: name, updateQRCode)
            .onChange(of: email, updateQRCode)
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

    private func updateQRCode() {
        qrCode = generateQRCode(from: "\(name)\n\(email)")
    }
}

#Preview {
    MeView()
}
