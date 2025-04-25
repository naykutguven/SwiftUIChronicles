//
//  IExpenseLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 25.04.25.
//

import SwiftUI

struct IExpenseLearningsContentView: View {
    @State private var user = User()
    @State private var showSheet = false

    var body: some View {
        VStack {
            let _ = Self._printChanges()
            TextField("First Name", text: $user.firstName)
                .textFieldStyle(.roundedBorder)
                .padding()
                .background(Color.random)
            TextField("Last Name", text: $user.lastName)
                .textFieldStyle(.roundedBorder)
                .padding()
                .background(Color.random)
            Text("Hello \(user.firstName) \(user.lastName)")

            Button("Show the sheet") {
                showSheet = true
            }
            .sheet(
                isPresented: $showSheet,
                onDismiss: {
                    showSheet = false
                }
            ) {
                SheetContentView()
            }
        }
    }
}

private struct SheetContentView: View {
    // A handy built-in environment value that is used to dismiss a view
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button("Dismiss") {
            dismiss()
        }
    }
}

// Since `User` is a class, it is a reference type. This means that when we
// change its properties, the `IExpenseContentView` will not be reloaded
// automatically without `@Observable`. This is because the object itself is not being replaced,
// only its properties are, and SwiftUI doesn't see this as achange that requires
// a reload. If it was a value type (like a struct), SwiftUI would see it as a change
// and would reload the view because we need to make a copy of the struct to change its properties.
// To make it work, we need to use `@Observable` macro for classes.
// Try it out by replacing `User` with a struct and see the difference.
@Observable
private class User {
    var firstName: String = "Frodo"
    var lastName: String = "Baggins"
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// MARK: - onDelete

private struct ForEachOnDeleteContentView: View {
    @State private var nums = [Int]()
    @State private var currentNumber = 0

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(nums, id: \.self) { num in
                        Text("\(num)")
                            .padding()
                    }
                    // swipe to delete action
                    .onDelete { indexSet in
                        nums.remove(atOffsets: indexSet)
                    }

                }

                Button("Add Number") {
                    nums.append(currentNumber)
                    currentNumber += 1
                }
            }
            // For this to work, we need to put the VStack inside a NavigationStack
            .toolbar {
                EditButton()
            }
        }
    }
}

// MARK: - UserDefaults and @AppStorage and Codable

private struct UserDefaultsAppStorageContentView: View {
    @State private var userDefaultsTapCount = UserDefaults.standard.integer(forKey: "userDefaultsTapCount")

    /// Notice how easy it is to use `@AppStorage` property wrapper compared to
    /// UserDefaults. Also, it works like @State - the view is updated automatically.
    /// However, it has limitations, too. For example, it doesn't make it easy
    /// to store complex objects like structs. Use it only for Bools and Integers and so on.
    @AppStorage("appStorageTapCount") private var appStorageTapCount = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("UserDefaults Tap Count: \(userDefaultsTapCount)")
            Button("Increment UserDefaults Tap Count") {
                userDefaultsTapCount += 1
                UserDefaults.standard.set(userDefaultsTapCount, forKey: "userDefaultsTapCount")
            }
            Text("AppStorage Tap Count: \(appStorageTapCount)")
            Button("Increment AppStorage Tap Count") {
                appStorageTapCount += 1
            }

            // Storing complex objects in UserDefaults
            Button("Store User") {
                let user = StorableUser(firstName: "Frodo", lastName: "Baggins")
                if let encoded = try? JSONEncoder().encode(user) {
                    UserDefaults.standard.set(encoded, forKey: "user")
                }
            }
        }
    }
}

private struct StorableUser: Codable {
    let firstName: String
    let lastName: String
}

// MARK: - Previews

#Preview {
    IExpenseLearningsContentView()
}

#Preview("ForEach onDelete") {
    ForEachOnDeleteContentView()
}

#Preview("UserDefaults and AppStorage") {
    UserDefaultsAppStorageContentView()
}

