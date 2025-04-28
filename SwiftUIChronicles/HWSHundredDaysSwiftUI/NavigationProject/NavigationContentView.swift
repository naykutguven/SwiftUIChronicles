//
//  NavigationContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 27.04.25.
//

import SwiftUI

struct NavigationContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Tap Me") {
                // Here is the problem with using simple NavigationLink
                // The initializer of `DetailView` is already called before
                // tapping the link. Imagine doing this in a list with 1000 items.
                DetailView(number: 556)
            }

            // In this approach, the initializer of `DetailView` is not called
            // until the link is tapped. This is the recommended way to
            // use NavigationLink in a list.
            // We simply attach a Hashable value to the link and use
            // `navigationDestination` to create the destination view.
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
                DetailView(number: selection)
            }
        }
    }
}

private struct DetailView: View {
    var number: Int

    var body: some View {
        Text("Detail View \(number)")
    }

    init(number: Int) {
        self.number = number
        print("Creating detail view \(number)")
    }
}

// MARK: - Programmatic Navigation Using `path`

private struct ProgrammaticNavigationContentView: View {
    // Note that path can store only a single type of value. What if we want to
    // navigate to different types? We can use `NavigationPath` for that.
    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            List(0..<100) { i in
                Button("Select \(i)") {
                    path.append(i)
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }

            Button("Show 32 then 64") {
                path = [32, 64]
            }
        }
    }
}

// MARK: - Navigating to different types using NavigationPath

private struct DifferentTypesNavigationContentView: View {
    /// If we want to navigate all the way  back to the root view, we can
    /// simply set the path to an empty array or set a new NavigationPath
    /// instance to it. We need to use `@Binding` instead of `@State` and
    /// pass the current path to subviews to achieve this.
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Int navigation") {
                    ForEach(0..<5) { i in
                        NavigationLink("Select \(i)", value: i)
                    }
                }

                Section("String navigation") {
                    ForEach(0..<5) { i in
                        NavigationLink("Select \(i)", value: String(i))
                    }
                }
            }
            .toolbar {
                Button("Push 556") {
                    path.append(556)
                }

                Button("Push Hello") {
                    path.append("Hello")
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection)")
            }
        }
    }
}

// MARK: - Re/stroing the path using Codable

private struct RestoringPathContentView: View {
    /// So, when we relaunch the app, we can restore the path.
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.navPath) {
            PathDetailView(number: 0)
                .navigationDestination(for: Int.self) { selection in
                    PathDetailView(number: selection)
                }
        }
    }
}

private struct PathDetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to a random number", value: Int.random(in: 0..<100))
            .navigationTitle("Number: \(number)")
    }
}

@Observable
private class PathStore {
//    var intPath: [Int] = [] {
//        didSet {
//            save()
//        }
//    }

    var navPath: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavePath")

    init() {
//        if let data = try? Data(contentsOf: savePath),
//           let decoded = try? JSONDecoder().decode([Int].self, from: data) {
//            intPath = decoded
//        } else {
//            intPath = []
//        }

        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
            navPath = NavigationPath(decoded)
        } else {
            navPath = NavigationPath()
        }
    }

    private func save() {
//        guard let data = try? JSONEncoder().encode(intPath) else {
//            return
//        }
//        try? data.write(to: savePath)

        guard let codableRep = navPath.codable,
              let data = try? JSONEncoder().encode(codableRep) else {
            return
        }

        try? data.write(to: savePath)
    }
}

// MARK: - Previews

#Preview {
    NavigationContentView()
}

#Preview("Programmatic Navigation") {
    ProgrammaticNavigationContentView()
}

#Preview("Navigating to different types using NavigationPath") {
    DifferentTypesNavigationContentView()
}

#Preview("Restoring Path") {
    RestoringPathContentView()
}
