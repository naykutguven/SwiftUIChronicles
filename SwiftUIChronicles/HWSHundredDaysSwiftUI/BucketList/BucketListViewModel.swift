//
//  BucketListViewModel.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 02.05.25.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

extension BucketListContentView {
    // MVVM and SwiftData don't play well together
    // Check here for more details: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-mvvm-to-separate-swiftdata-from-your-views
    // Some tedious work. You lose most of convenience SwiftData brings.
    @Observable
    final class ViewModel {
        private(set) var locations: [BucketItemLocation]
        var selectedLocation: BucketItemLocation?

        var isUnlocked = false
        private let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")

        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([BucketItemLocation].self, from: data)
            } catch {
                locations = []
            }
        }

        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }

        func addLocation(at coordinate: CLLocationCoordinate2D) {
            let newLocation = BucketItemLocation(
                id: UUID(),
                name: "New Location",
                description: "Description",
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

            locations.append(newLocation)
            save()
        }

        func update(location: BucketItemLocation) {
            guard let selectedLocation else { return }

            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                ) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                    }
                }
            } else {

            }
        }
    }
}
