//
//  CupcakeCornerLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 28.04.25.
//

import SwiftUI

struct CupcakeCornerLearningsContentView: View {
    @State private var results = [Result]()

    var body: some View {
        List(results, id: \.trackId) { result in
            VStack(alignment: .leading) {
                Text(result.trackName)
                    .font(.headline)

                Text(result.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }

    private func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=metallica&entity=song") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Failed to decode JSON")
                return
            }
            results = decodedResponse.results
        } catch {
            print("Invalid data")
        }
    }
}

// MARK: - Loading Image

private struct LoadImageContentView: View {
    var body: some View {
        // Using resizable directly on AsyncImage doesn't work here. So
        // do the following to make it work.
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 200, height: 200)

        // Now if we want more control over the image, we can use the following
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("Failed to load image")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

// MARK: - Disabling Forms

private struct DisableFormContentView: View {
    @State private var name = ""
    @State private var email = ""

    private var isFormDisabled: Bool {
        name.isEmpty || email.isEmpty
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
            }

            Section {
                Button("Submit") {
                    print("Submitted")
                }
            }
            .disabled(isFormDisabled)
        }
    }
}

// MARK: - Data Models

private struct Response: Codable {
    let results: [Result]
}

private struct Result: Codable {
    let trackId: Int
    let trackName: String
    let collectionName: String
}

// MARK: - Previews

#Preview {
    CupcakeCornerLearningsContentView()
}

#Preview("Loading Image") {
    LoadImageContentView()
}

#Preview("Disable Form") {
    DisableFormContentView()
}
