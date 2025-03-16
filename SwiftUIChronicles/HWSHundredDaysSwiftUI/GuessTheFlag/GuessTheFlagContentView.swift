//
//  GuessTheFlagContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 16.03.25.
//

import SwiftUI

struct GuessTheFlagContentView: View {
    @State private var showAlert = false

    var body: some View {
        // MARK: - Stacks

//        ZStack {
//            VStack(spacing: 0) {
//                Color.red
//                Color.blue
//            }
//
//            Text("Your content")
//                .foregroundStyle(.secondary)
//                .padding(50)
//                .background(.ultraThinMaterial)
//        }
//        .ignoresSafeArea()

        // MARK: - Gradient
//        LinearGradient(
//            colors: [.red, .blue],
//            startPoint: .top,
//            endPoint: .bottom
//        )
//
//        LinearGradient(
//            stops: [
//                .init(color: .red, location: 0.4),
//                .init(color: .blue, location: 0.6)
//            ],
//            startPoint: .top,
//            endPoint: .bottom
//        )
//
//        AngularGradient(
//            colors: [.red, .yellow, .green, .blue, .purple],
//            center: .center
//        )
//
//        RadialGradient(
//            colors: [.red, .yellow, .green, .blue, .purple],
//            center: .center,
//            startRadius: 10,
//            endRadius: 200
//        )
//
//        if #available(iOS 18.0, *) {
//            MeshGradient(width: 3, height: 3, points: [
//                .init(0, 0), .init(0.5, 0), .init(1, 0),
//                .init(0, 0.5), .init(0.5, 0.5), .init(1.0, 0.5),
//                .init(0, 1), .init(0.5, 1), .init(1, 1)
//            ], colors: [
//                .red, .purple, .indigo,
//                .orange, .white, .blue,
//                .yellow, .green, .mint
//            ])
//        }

        // MARK: - Buttons

        VStack {
            Button("Button 1") { }
                .buttonStyle(.bordered)
            Button("Button 2", role: .destructive) { }
                .buttonStyle(.bordered)
            Button("Button 3") { }
                .buttonStyle(.borderedProminent)
            Button("Button 4", role: .destructive) { }
                .buttonStyle(.borderedProminent)

            Button {
                print("Button with image")
            } label: {
                Label("Edit", systemImage: "pencil")
                    .padding()
                    .foregroundStyle(.white)
                    .background(.red)
                    .clipShape(.buttonBorder)
            }
        }

        // MARK: - Alerts

        Button {
            showAlert = true
        } label: {
            Label("Show alert", systemImage: "bell")
                .padding()
                .foregroundStyle(.white)
                .background(.red)
                .clipShape(.buttonBorder)
        }
        .alert("Important Message", isPresented: $showAlert) {
            Button("Delete", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please read this.")
        }
    }
}

#Preview {
    GuessTheFlagContentView()
}
