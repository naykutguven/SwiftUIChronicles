//
//  BucketListContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 02.05.25.
//

import MapKit
import SwiftUI

struct BucketListContentView: View {
    @State private var viewModel = ViewModel()

    private let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
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
                                    viewModel.selectedLocation = location
                                }
                        }
                    }
                }
                .onTapGesture { position in // in screen coordinates
                    guard let coordinate = proxy.convert(position, from: .local) else { return }
                    viewModel.addLocation(at: coordinate)
                }
                .sheet(item: $viewModel.selectedLocation) { place in
                    BucketItemLocationEditView(location: place) {
                        viewModel.update(location: $0)
                    }
                }
            }
        } else {
            Button("Unlock", action: viewModel.authenticate)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(.capsule)
        }
    }
}

// MARK: - LocationEditView

private struct BucketItemLocationEditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }

    @Environment(\.dismiss) private var dismiss
    var location: BucketItemLocation
    var onSave: (BucketItemLocation) -> Void

    @State private var name: String = ""
    @State private var description: String = ""

    @State private var loadingState = LoadingState.loading
    @State private var pages = [WikiPage]()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }

                Section("Nearby…") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text("\(page.description)")
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
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
            .task {
                await fetchNearbyPlaces()
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

    private func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // we got some data back!
            let items = try JSONDecoder().decode(WikiResult.self, from: data)

            // success – convert the array values to our pages array
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            // if we're still here it means the request failed somehow
            loadingState = .failed
        }
    }
}


// MARK: - Data models

struct BucketItemLocation: Codable, Equatable, Identifiable {
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

struct WikiResult: Codable {
    let query: WikiQuery
}

struct WikiQuery: Codable {
    let pages: [Int: WikiPage]
}

struct WikiPage: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?

    var description: String {
        terms?["description"]?.first ?? ""
    }

    static func < (lhs: WikiPage, rhs: WikiPage) -> Bool {
        lhs.title < rhs.title
    }
}

// MARK: - Previews

#Preview {
    BucketListContentView()
}
