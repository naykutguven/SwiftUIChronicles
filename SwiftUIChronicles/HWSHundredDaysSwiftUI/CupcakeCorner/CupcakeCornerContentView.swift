//
//  CupcakeCornerContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 28.04.25.
//

import SwiftUI

struct CupcakeCornerContentView: View {
    @State private var order = Order()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }

                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())

                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }

                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

private struct AddressView: View {
    var order: Order

    var body: some View {
        Text("Hello World")
    }
}

// MARK: - Data Models

@Observable
private class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
}

// MARK: - Previews

#Preview {
    CupcakeCornerContentView()
}
