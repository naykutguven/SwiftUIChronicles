//
//  BucketListLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 02.05.25.
//

import LocalAuthentication
import MapKit
import SwiftUI

struct BucketListLearningsContentView: View {
    private let users = [
        HWSExampleUser(firstName: "Arnold", lastName: "Rimmer"),
        HWSExampleUser(firstName: "Kristine", lastName: "Kochanski"),
        HWSExampleUser(firstName: "David", lastName: "Lister"),
    ]
        .sorted()

    var body: some View {
        List(users) { user in
            Text("\(user.lastName), \(user.firstName)")
        }
    }
}

// Example of Comparable protocol. It isn't like Equatable.
private struct HWSExampleUser: Identifiable, Comparable {
    let id = UUID()
    var firstName: String
    var lastName: String

    static func < (lhs: HWSExampleUser, rhs: HWSExampleUser) -> Bool {
        lhs.firstName < rhs.firstName
    }
}

// MARK: - Writing data to the documents directory

private struct WriteToDocumentsDirectoryContentView: View {
    var body: some View {
        Button("Read and Write") {
            let data = Data("Hello, World!".utf8)
            let url = URL.documentsDirectory.appendingPathComponent("message.txt")

            do {
                // These options are good to have.
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let readData = try Data(contentsOf: url)
                print("Read data: \(readData)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MapKit

private struct MapKitContentView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )

    var body: some View {
        Map(position: $position)
            .mapStyle(.hybrid)
            .onMapCameraChange(frequency: .continuous) { context in
                print(context.region)
            }

        HStack(spacing: 50) {
            Button("Paris") {
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    )
                )
            }

            Button("Tokyo") {
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    )
                )
            }
        }
    }
}

// MARK: - Adding Markers on Map

private struct MapKitMarkersContentView: View {
    let locations = [
        HWSLocation(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        HWSLocation(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]

    var body: some View {
        Map {
            ForEach(locations) { location in
                // simplest way to add a marker
                Marker(location.name, coordinate: location.coordinate)
            }
        }
    }
}

// MARK: - Adding Annotations on Map

private struct MapKitAnnotationsContentView: View {
    let locations = [
        HWSLocation(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        HWSLocation(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]

    var body: some View {
        // Use MapReader to convert screen locations to coordinates
        MapReader { proxy in
            Map {
                ForEach(locations) { location in
                    // a bit more customization
                    Annotation(location.name, coordinate: location.coordinate) {
                        Text(location.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue.gradient)
                            .clipShape(.capsule)
                    }
                    .annotationTitles(.hidden)
                }
            }
            .onTapGesture { position in
                // Convert screen position to coordinate. Global or local coordinate space
                if let coordinate = proxy.convert(position, from: .global) {
                    print("Coordinate: \(coordinate.latitude), \(coordinate.longitude)")
                }
            }
        }
    }
}

// MARK: - Location Model

private struct HWSLocation: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

// MARK: - FaceID

private struct FaceIDContentView: View {
    // You can set this on simulator to test FaceID
    @State private var isUnlocked = false

    var body: some View {
        Text("FaceID")

        VStack {
            if isUnlocked {
                Text("Unlocked!")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }

    private func authenticate() {
        let context = LAContext()

        // LocalAuthentication framework is written in Objective-C
        // so we need to use NSError to handle errors
        var error: NSError?

        // First we need to check if the device has FaceID or TouchID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your data"
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason) { success, authError in
                    if success {
                        // authenticated
                        isUnlocked = true
                    } else {
                        // authentication failed
                    }
                }
        } else {
            // no biometrics available
        }
    }
}

// MARK: - Previews

#Preview {
    BucketListLearningsContentView()
}

#Preview("Read and write from documents directory") {
    WriteToDocumentsDirectoryContentView()
}

#Preview("MapKit") {
    MapKitContentView()
}

#Preview("MapKit Markers") {
    MapKitMarkersContentView()
}

#Preview("MapKit Annotaions") {
    MapKitAnnotationsContentView()
}

#Preview("FaceID") {
    FaceIDContentView()
}
