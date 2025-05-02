//
//  BucketListContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 02.05.25.
//

import MapKit
import SwiftUI

struct BucketListContentView: View {
    @State private var locations: [BucketItemLocation] = []
    @State private var selectedLocation: BucketItemLocation?

    private let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        // ugly, but works
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                        // This is problematic in MapKit... it doesn't
                        // work as expected. Map always receives the gesture.
                            .onLongPressGesture {
                                selectedLocation = location
                            }
                    }
                }
            }
            .onTapGesture { position in // in screen coordinates
                guard let coordinate = proxy.convert(position, from: .local) else { return }

                let newLocation = BucketItemLocation(
                    id: UUID(),
                    name: "New Location",
                    description: "Description",
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )

                locations.append(newLocation)
            }
            .sheet(item: $selectedLocation) { place in
                LocationEditView(location: place) { newLocation in
                    if let index = locations.firstIndex(of: newLocation) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

// MARK: - LocationEditView

private struct LocationEditView: View {
    @Environment(\.dismiss) private var dismiss
    var location: BucketItemLocation
    var onSave: (BucketItemLocation) -> Void

    @State private var name: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.name = name
                    newLocation.description = description

                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }

    // we need to do this because the selected location is optional
    init(location: BucketItemLocation, onSave: @escaping (BucketItemLocation) -> Void) {
        self.location = location
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}


// MARK: - Data models

private struct BucketItemLocation: Codable, Equatable, Identifiable {
    #if DEBUG
    static let example = BucketItemLocation(
        id: UUID(),
        name: "Buckingham Palace",
        description: "Lit by over 40,000 lightbulbs.",
        latitude: 51.501,
        longitude: -0.141
    )
    #endif

    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Equatable
    static func ==(lhs: BucketItemLocation, rhs: BucketItemLocation) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Previews

#Preview {
    BucketListContentView()
}
