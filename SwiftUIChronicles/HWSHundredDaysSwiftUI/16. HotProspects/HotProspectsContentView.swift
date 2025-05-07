//
//  HotProspectsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.05.25.
//

import SwiftData
import SwiftUI

struct HotProspectsContentView: View {
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }

            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }

            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }

            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
    }
}

// MARK: - Previews

#Preview {
    HotProspectsContentView()
        .modelContainer(for: Prospect.self)
}
