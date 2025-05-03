//
//  ProspectsView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.05.25.
//


import CodeScanner
import SwiftData
import SwiftUI

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Prospect.name) private var prospects: [Prospect]

    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()

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
            List(prospects, selection: $selectedProspects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)

                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                    }
                }
                // To help SwiftUI understand that each row in our List
                // corresponds to a single prospect, it's important to add
                // a tag after the swipe actions
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // We can't have a button that is not wrapped inside
                    // a ToolbarItem when we have other ToolbarItems.
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", systemImage: "trash", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                // This is provided by Paul Hudson of HWS.
                // We could use AVFoundation as well but he says it is
                // too complicated for this simple task.
                // Regardless, We also need to add a privacy key to Info.plist
                CodeScannerView(
                    codeTypes: [.qr],
                    simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                    completion: handleScan
                )
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

    private func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect(
                name: details[0],
                emailAddress: details[1],
                isContacted: false
            )

            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    private func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
