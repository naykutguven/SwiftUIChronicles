//
//  BetterRestContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 26.03.25.
//

import CoreML
import SwiftUI

struct BetterRestContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden() // still audible in VoiceOver
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(
                        "\(sleepAmount.formatted()) hours",
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25
                    )
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)

                    // SwiftUI supports Markdown string localization syntax with inflection support in iOS 17.0
                    Stepper(
                        "^[\(coffeeAmount) cup](inflect: true)",
                        value: $coffeeAmount,
                        in: 1...20
                    )
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(
                alertTitle,
                isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                message: {
                    Text(alertMessage)
                }
        }
    }

    private func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents(
                [.hour, .minute],
                from: wakeUp
            )
            let hour = (components.hour ?? 0) * 60 * 60 // in seconds
            let minute = (components.minute ?? 0) * 60 // in seconds

            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: Double(sleepAmount),
                coffee: Double(coffeeAmount)
            )

            let sleepTime = wakeUp - prediction.actualSleep

            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "There was a problem calculating your bedtime."
        }

        showingAlert = true
    }
}

#Preview {
    BetterRestContentView()
}
