//
//  HotProspectsLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.05.25.
//

import SwiftUI

struct HotProspectsLearningsContentView: View {
    private let users = ["Tohru", "Yuki", "Kyo", "Momiji"]
    @State private var selectedUser: String?

    // If we pass a set instead, we can select multiple items. Simple as that.
    @State private var selectedUsers = Set<String>()

    var body: some View {
        // pretty easy to add a basic selection
        List(users, id: \.self, selection: $selectedUser) { user in
            Text(user)
        }

        if let selectedUser {
            Text("You selected \(selectedUser)")
        }

        // We need to swipe right with two fingers to activate multiple selection
        List(users, id: \.self, selection: $selectedUsers) { user in
            Text(user)
        }

        if selectedUsers.isEmpty == false {
            Text("You selected \(selectedUsers.formatted())")
        }
    }
}

// MARK: - TabView

private struct TabViewContentView: View {
    @State private var selectedTab = ""

    var body: some View {
        TabView {
            Text("Tab 1")
                .tabItem {
                    Label("One", systemImage: "star")
                }

            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }
        }
    }
}

// MARK: - TabView selection

private struct TabViewSelectionContentView: View {
    @State private var selectedTab = "one"

    var body: some View {
        TabView(selection: $selectedTab) {
            Button("Show Tab 2") {
                selectedTab = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")

            Text("Tab 2")
                .tabItem {
                    Label("Two", systemImage: "circle")
                }// tags are pretty useful in TabViews
                .tag("Two")
        }
    }
}

// MARK: - Context menu and deep touch

private struct ContextMenuContentView: View {
    @State private var backgroundColor = Color.red

    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)

            Text("Change Color")
                .padding()
                // This is a context menu which is shown when we
                // long (deep) press on the view
                .contextMenu {
                    Button("Red") {
                        backgroundColor = .red
                    }

                    Button("Green") {
                        backgroundColor = .green
                    }

                    Button("Blue") {
                        backgroundColor = .blue
                    }
                }
        }
    }
}

// MARK: - Previews

#Preview {
    HotProspectsLearningsContentView()
}

#Preview("TabView") {
    TabViewContentView()
}

#Preview("TabView Selection") {
    TabViewSelectionContentView()
}

#Preview("Context Menu") {
    ContextMenuContentView()
}
