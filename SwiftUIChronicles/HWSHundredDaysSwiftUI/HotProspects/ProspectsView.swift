//
//  ProspectsView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.05.25.
//

import SwiftData
import SwiftUI

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Prospect.name) private var prospects: [Prospect]

    let filter: FilterType

    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }

    var body: some View {
        NavigationStack {
            List(prospects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)

                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }

            }
            .navigationTitle(title)
            .toolbar {
                Button("Scan", systemImage: "qrcode.viewfinder") {
                    let prospect = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false)
                    modelContext.insert(prospect)
                }
            }
        }
    }

    init(filter: FilterType) {
        self.filter = filter
        if filter != .none {
            // This local variable is needed because if we directly use
            // $0.isContacted == (filter == .contacted) in the filter closure
            // Preview raises an error: Member access without an explicit
            // base is not supported in this predicate
            let isContactsOnly = filter == .contacted
            _prospects = Query(
                filter: #Predicate {
                    $0.isContacted == isContactsOnly
                },
                sort: [SortDescriptor(\Prospect.name)]
            )
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
