//
//  HWSAnimationsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 23.04.25.
//

import SwiftUI

struct HWSAnimationsContentView: View {
    @State private var animationAmout: CGFloat = 1.0
    @State private var scaleAnimationAmout: CGFloat = 1.0
    @State private var rotationAmount: Double = 0.0

    var body: some View {
        VStack {
            Button("Tap me") {
                animationAmout += 0.1
            }
            .padding(50)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .stroke(.blue)
                    .scaleEffect(animationAmout)
                    .opacity(2 - animationAmout)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: false),
                        value: animationAmout
                    )
            }
            .onAppear {
                // this is necessary to start the animation
                animationAmout = 2
            }

            VStack(spacing: 100) {
                Stepper(
                    "Scale: \(scaleAnimationAmout, specifier: "%.1f")",
                    value: $scaleAnimationAmout.animation(), // this changes the binding with animation.
                    in: 1...10
                )
                Button("Tap me") {
                    // this us a state change without animation. So, the button will
                    // scale up without animation.
                    scaleAnimationAmout += 0.1
                }
                .padding(50)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(.circle)
                .scaleEffect(scaleAnimationAmout)
            }

            Button("Tap me") {
                withAnimation(.linear(duration: 2.0)) {
                    // this is a state change with explicit animation. So, the button will
                    // rotate with animation.
                    rotationAmount += 360
                }
            }
            .padding(50)
            .background(.orange)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(rotationAmount), axis: (x: 0, y: 1, z: 0))
        }
    }
}

private struct HWSMoreAnimationsContentView: View {
    @State private var dragAmount: CGSize = .zero
    @State private var flag = false

    // the order of animations matters
    var body: some View {
        Button("Tap me") {
            flag.toggle()
        }
        .frame(width: 100, height: 100)
        .background(flag ? .blue : .red)
        .foregroundColor(.white)
        .animation(.default, value: flag)
        .clipShape(.rect(cornerRadius: flag ? 50 : 0))
        .animation(.spring, value: flag)

        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .aspectRatio(1.5, contentMode: .fit)
            .frame(width: 300)
            .clipShape(.rect(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in withAnimation(.bouncy) { dragAmount = .zero } }
            )
    }
}

private struct HWSCoolGestureSnakeAnimationContentView: View {
    private let letters = Array("Hello there")
    @State private var dragAmount: CGSize = .zero
    @State private var flag = false

    var body: some View {
        HStack(spacing: 0) {
            ForEach(letters.indices, id: \.self) { index in
                Text(String(letters[index]))
                    .padding(5)
                    .background(flag ? .blue : .red)
                    .foregroundColor(.white)
                    .clipShape(.rect(cornerRadius: dragAmount != .zero ? 10 : 0))
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(index) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    flag.toggle()
                }
        )
    }
}

// MARK: - Previews

#Preview {
    HWSAnimationsContentView()
}

#Preview("More animations") {
    HWSMoreAnimationsContentView()
}

#Preview("More cool animations") {
    HWSCoolGestureSnakeAnimationContentView()
}
