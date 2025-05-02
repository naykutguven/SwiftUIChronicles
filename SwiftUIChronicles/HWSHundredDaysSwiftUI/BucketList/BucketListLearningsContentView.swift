//
//  BucketListLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 02.05.25.
//

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

// MARK: - Previews

#Preview {
    BucketListLearningsContentView()
}

#Preview("Read and write from documents directory") {
    WriteToDocumentsDirectoryContentView()
}
