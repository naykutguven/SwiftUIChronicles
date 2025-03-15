//
//  WeSplitContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 15.03.25.
//

import SwiftUI

struct WeSplitContentView: View {
    @State private var tapCount = 0
    @State private var name = ""

    private let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"

    var body: some View {
        Form {
            Section {
                Button("Tap count: \(tapCount)") {
                    tapCount += 1
                }
            }
            Section {
                TextField("Enter your name", text: $name)
                Text("Your name is \(name)")
            }
            Section(header: Text("Select your student")) {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
    }
}

#Preview {
    WeSplitContentView()
}
