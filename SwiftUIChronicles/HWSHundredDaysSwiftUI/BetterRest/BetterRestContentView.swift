//
//  BetterRestContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 26.03.25.
//

import SwiftUI

struct BetterRestContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now

    var body: some View {
        Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12, step: 0.25)
        DatePicker("Please enter a time", selection: $wakeUp, in: Date.now...) // Pretty cool, right?

        Text(Date.now.formatted())
        Text(Date.now, format: .dateTime.day().month().hour().minute())
        Text(Date.now.formatted(date: .long, time: .shortened))
    }
}

#Preview {
    BetterRestContentView()
}
