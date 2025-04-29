//
//  SwiftDataTipsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 29.04.25.
//

import SwiftData
import SwiftUI

struct SwiftDataTipsContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        // This is how we can filter in SwiftData.
        filter: #Predicate<HWSSwiftDataUser> { user in
            user.name.contains("R")
        },
        sort: \HWSSwiftDataUser.name
    ) private var users: [HWSSwiftDataUser]
//    @State private var path = [HWSSwiftDataUser]()

    var body: some View {
        NavigationStack /* (path: $path) */ {
            List(users) { user in
                NavigationLink(value: user) {
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
//            .navigationDestination(for: HWSSwiftDataUser.self) { user in
//                EditUserView(user: user)
//            }
            .toolbar {
                Button("Add User", systemImage: "plus") {
                    try? modelContext.delete(model: HWSSwiftDataUser.self)
                    let first = HWSSwiftDataUser(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = HWSSwiftDataUser(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = HWSSwiftDataUser(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = HWSSwiftDataUser(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
//                    let user = HWSSwiftDataUser(name: "", city: "", joinDate: .now)
//                    modelContext.insert(user)
                    // Basically, inserting a new EditUserView into the navigation stack which then executes navigationDestination. Pretty easy, huh?
                    // This is very similar to what Notes app does when you create a new note.
                    // path = [user]
                }
            }
        }
    }
}

// MARK: - Helper views

private struct EditUserView: View {
    @Bindable var user: HWSSwiftDataUser

    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - SwiftData models

@Model
final class HWSSwiftDataUser {
    var name: String
    var city: String
    var joinDate: Date

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

// MARK: - Previews

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    if let container = try? ModelContainer(for: HWSSwiftDataUser.self, configurations: config) {
        let user = HWSSwiftDataUser(name: "Aykut Güven", city: "Istanbul", joinDate: .now)
        SwiftDataTipsContentView()
            .modelContainer(container)
    }
}
