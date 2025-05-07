//
//  CupcakeCornerLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 28.04.25.
//

import CoreHaptics
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

// MARK: - Conforming Codable in Observable classes

@Observable
private class BrokenObservableCodableUser: Codable {
    var name = "Aykut"
}

@Observable
private class CorrectObservableCodableUser: Codable {
    private enum CodingKeys: String, CodingKey {
        case _name = "name"
    }

    var name = "Aykut"
}

private struct ObservableCodableContentView: View {
    var body: some View {
        Button("Encode broken observable", action: encodeUser)
        Button("Encode correct observable", action: encodeCorrectUser)
    }

    func encodeUser() {
        let data = try! JSONEncoder().encode(BrokenObservableCodableUser())
        let str = String(decoding: data, as: UTF8.self)
        // Prints {"_name":"Aykut","_$observationRegistrar":{}} because
        // Observable macro is rewriting the class behind the scenes.
        // This can create problems when we send this data to a server.
        // The server doesn't expect the underscore prefixed keys. So, we need
        // to define our own CodingKeys enum to avoid this.
        print(str)
    }

    func encodeCorrectUser() {
        let data = try! JSONEncoder().encode(CorrectObservableCodableUser())
        let str = String(decoding: data, as: UTF8.self)
        // Prints {"name":"Aykut"} only
        print(str)
    }
}

// MARK: - Haptics

private struct HapticFeedbackContentView: View {
    @State private var counter = 0
    @State private var engine: CHHapticEngine?

    var body: some View {
        Button("Tap count: \(counter)") {
            counter += 1
        }
        .sensoryFeedback(.increase, trigger: counter)

        // More advanced stuff
        Button("Complex haptics ") {
            complexSuccess()
        }
        // This is necessary to prepare the haptic engine.
        .onAppear(perform: prepareHaptics)
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }

    // Advanced haptics
    private func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        var events = [CHHapticEvent]()

        // You can add multiple events to create a complex pattern.
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error)")
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

#Preview("Observable Codable") {
    ObservableCodableContentView()
}

#Preview("Haptic Feedback") {
    HapticFeedbackContentView()
}
