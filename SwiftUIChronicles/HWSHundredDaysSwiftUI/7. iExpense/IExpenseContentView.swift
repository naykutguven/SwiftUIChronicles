//
//  IExpenseContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 24.04.25.
//

import Observation
import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
final class Expenses {
    var items: [ExpenseItem] = [] {
        didSet {
            guard let data = try? JSONEncoder().encode(items) else {
                return
            }

            UserDefaults.standard.set(data, forKey: "items")
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct IExpenseContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
            List {
                // Using `name` as the identifier without the type conforming
                // to `Identifiable` protocol just works but we end up having
                // non-unique items. It may also cause weird behaviors. That's why
                // we should prefer implementing `Identifiable` protocol.
                ForEach(expenses.items) { expenseItem in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expenseItem.name)
                                .font(.headline)
                            Text(expenseItem.type)
                        }
                        Spacer()
                        Text(expenseItem.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }

                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense.toggle()
                }
                EditButton()
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenses: expenses)
            }
        }
    }

    private func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

private struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var type = "Business"
    @State private var amount = 0.0

    var expenses: Expenses

    private let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                            .buttonStyle(.borderedProminent)
                    }
                }
                .buttonStyle(.borderedProminent)

                TextField(
                    "Amount",
                    value: $amount,
                    format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                )
                .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}


// MARK: - Previews

#Preview {
    IExpenseContentView()
}
