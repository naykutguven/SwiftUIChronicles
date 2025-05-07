//
//  BookwormLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 29.04.25.
//

import SwiftData
import SwiftUI

struct BookwormLearningsContentView: View {
    @State private var rememberMe = false
    @AppStorage("notes") private var notes = "Hello, world!"

    var body: some View {
        VStack {
            // Just a Binding example
            PushButton(title: "Push me", isOn: $rememberMe)
            Text("Remember me: \(rememberMe ? "On" : "Off")")

            // Wraps across many lines. It's like UITextView, has a
            // fixed height (covers the proposed area, it seems) and scrollable.
            TextEditor(text: $notes)
                .padding()
            // With axis set as vertical, it can grow vertically automatically.
            TextField("Notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                
        }
    }
}

private struct PushButton: View {
    let title: String
    @Binding var isOn: Bool

    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom))
        .foregroundStyle(.white)
        .clipShape(.capsule)
        .shadow(radius: isOn ? 0 : 5)
    }
}

// MARK: - Introduction to SwiftData


private struct SwiftDataIntroContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var students: [Student]

    var body: some View {
        NavigationStack {
            List(students) { student in
                Text(student.name)
            }
            .navigationTitle("Students")
            .toolbar {
                Button("Add") {
                    let firstNames = ["Aykut", "Ali", "Ayşe", "Fatma", "Mehmet"]
                    let lastNames = ["Güven", "Yılmaz", "Kaya", "Demir", "Çelik"]

                    let chosenFirstName = firstNames.randomElement() ?? "Aykut"
                    let chosenLastName = lastNames.randomElement() ?? "Güven"

                    let student = Student(name: "\(chosenFirstName) \(chosenLastName)")
                    modelContext.insert(student)
                }
            }
        }
    }
}

@Model // Also works with @Observable
final class Student {
    var id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Previews

#Preview {
    BookwormLearningsContentView()
}

#Preview("Introduction to SwiftData") {
    SwiftDataIntroContentView()
}
