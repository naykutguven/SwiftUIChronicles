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
    @State private var showingUpcomingOnly = false

    @State private var sortOrder = [
        SortDescriptor(\HWSSwiftDataUser.name),
        SortDescriptor(\HWSSwiftDataUser.joinDate),
    ]

    var body: some View {
        NavigationStack /* (path: $path) */ {
            UsersView(
                minimumJoinDate: showingUpcomingOnly ? .now : .distantPast,
                sortOrder: sortOrder
            )
            .navigationTitle("Users")
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
                }

                Button(showingUpcomingOnly ? "Show All" : "Show Upcoming") {
                    showingUpcomingOnly.toggle()
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                        // This is very useful in Pickers and TabViews
                        // We can show different views for each selection
                        // and get the value type we want from tags
                            .tag([
                                SortDescriptor(\HWSSwiftDataUser.name),
                                SortDescriptor(\HWSSwiftDataUser.joinDate)
                            ])
                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\HWSSwiftDataUser.joinDate),
                                SortDescriptor(\HWSSwiftDataUser.name)
                            ])
                    }
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

private struct UsersView: View {
    @Query var users: [HWSSwiftDataUser]

    var body: some View {
        List(users) { user in
            Text(user.name)
        }
    }

    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<HWSSwiftDataUser>]) {
        // we are changing the underlying query, not the list itself
        _users = Query(
            filter: #Predicate<HWSSwiftDataUser> { user in
                user.joinDate >= minimumJoinDate
            },
            sort: sortOrder
        )
    }
}

// MARK: - SwiftData models

@Model
final class HWSSwiftDataUser {
    var name: String
    var city: String
    var joinDate: Date
    @Relationship(deleteRule: .cascade) var jobs = [HWSJob]()

    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}

@Model
final class HWSJob {
    var name: String
    var priority: Int
    var owner: HWSSwiftDataUser?

    init(name: String, priority: Int, owner: HWSSwiftDataUser? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
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
