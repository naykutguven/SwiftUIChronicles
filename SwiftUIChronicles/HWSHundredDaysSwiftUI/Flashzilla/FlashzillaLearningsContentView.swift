//
//  FlashzillaLearningsContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 04.05.25.
//

import SwiftUI

struct FlashzillaLearningsContentView: View {
    var body: some View {
        Text("Tap once")
            .tapStyle()
            .onTapGesture {
                print("Tapped once")
            }

        Text("Tap twice")
            .tapStyle()
            .onTapGesture(count: 2) {
                print("Tapped twice")
            }

        Text("Long tap")
            .tapStyle()
            .onLongPressGesture(minimumDuration: 2) {
                print("Long pressed!")
            }

        Text("Long tap with feedback")
            .tapStyle()
            .onLongPressGesture(minimumDuration: 2) {
                print("Long pressed!")
            } onPressingChanged: { inProgres in
                print("In progress: \(inProgres)")
            }


    }
}

// MARK: - Magnify gesture

private struct MagnifyGestureContentView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0

    var body: some View {
        Text("Hello, World!")
            .frame(width: 200, height: 200)
            .tapStyle()
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentAmount = value.magnification - 1
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}

// MARK: - Rotate gesture

private struct RotateGestureContentView: View {
    @State private var currentAmount = Angle.zero
    @State private var finalAmount = Angle.zero

    var body: some View {
        Text("Hello, World!")
            .tapStyle()
            .frame(width: 200, height: 200)
            .rotationEffect(currentAmount + finalAmount)
            .gesture(
                RotateGesture()
                    .onChanged { value in
                        currentAmount = value.rotation
                    }
                    .onEnded { value in
                        finalAmount += currentAmount
                        currentAmount = .zero
                    }
            )
    }
}

// MARK: - Gesture Priority

private struct GesturePriorityContentView: View {
    var body: some View {
        VStack(spacing: 50) {
            // In this case, SwiftUI always gives priority to the child view
            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .onTapGesture {
                print("VStack tapped")
            }

            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            // We need to call highPriorityGesture to give priority to the VStack
            .highPriorityGesture(
                TapGesture()
                    .onEnded {
                        print("VStack tapped")
                    }
            )

            // We could also have simultaneous gestures, like so
            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            // In this case, the VStack will always be tapped first
            // and then the Text will be tapped
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        print("VStack tapped")
                    }
            )
        }
    }
}

private struct GestureSequenceContentView: View {
    @State private var offset = CGSize.zero
    @State private var isDragging = false

    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    // Moves it back to its original position
                    offset = .zero
                    isDragging = false
                }
            }

        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }

        // This way, we can combine the two gestures and control user flow
        let combined = pressGesture.sequenced(before: dragGesture)

        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}

// MARK: - Hit Testing

private struct HitTestingContentView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
            // SwiftUI handles not receiving hits on the transparent
            // parts of the circle
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Circle tapped!")
                }
        }

        // There are multiple ways to change this behavior
        // allowsHitTesting(false)
        // or
        // contentShape(.rect)

        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Circle tapped!")
                }
                .allowsHitTesting(false) // Prints "Rectangle tapped!"
        }

        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("Rectangle tapped!")
                }

            Circle()
                .fill(.red)
                .frame(width: 200, height: 200)
                .contentShape(.rect) // Prints "Circle tapped!"
                .onTapGesture {
                    print("Circle tapped!")
                }
        }

        // We could use it in VStacks as well so users can tap on the spacing, too.
        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(.rect)
        .onTapGesture {
            print("VStack tapped!")
        }
    }
}

// MARK: - Timer

private struct TimerContentView: View {
    @State private var counter = 0
    // We could also add "tolerance" to the timer to make it more battery efficient
    // This means the OS can delay the timer just a bit to save battery.
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("Hello, World!")
            .onReceive(timer) { time in
                if counter == 5 {
                    timer.upstream.connect().cancel()
                } else {
                    print("The time is now \(time)")
                }

                counter += 1
            }
    }

    func cancelTimer() {
        // Kinda hard to find...
        timer.upstream.connect().cancel()
    }
}

// MARK: - App State

private struct AppStateContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Text("Hello, world!")
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    // Active scenes are running right now, which on iOS means
                    // they are visible to the user. On macOS an app’s window might
                    // be wholly hidden by another app’s window, but that’s okay
                    // – it’s still considered to be active.
                    print("Active")
                } else if newPhase == .inactive {
                    // Inactive scenes are running and might be visible to
                    // the user, but the user isn’t able to access them. For
                    // example, if you’re swiping down to partially reveal the
                    // control center then the app underneath is considered inactive.
                    print("Inactive")
                } else if newPhase == .background {
                    // Background scenes are not visible to the user, which on iOS
                    // means they might be terminated at some point in the future.
                    print("Background")
                }
            }
    }
}

// MARK: - Tap style

private extension View {
    func tapStyle() -> some View {
        self
            .padding()
            .background(.red.gradient)
            .foregroundColor(.white)
            .clipShape(.capsule)
    }
}

// MARK: - Previews

#Preview {
    FlashzillaLearningsContentView()
}

#Preview("Magnify gesture") {
    MagnifyGestureContentView()
}

#Preview("Rotate gesture") {
    RotateGestureContentView()
}

#Preview("Gesture priority") {
    GesturePriorityContentView()
}

#Preview("Gesture sequence") {
    GestureSequenceContentView()
}

#Preview("Hit testing") {
    HitTestingContentView()
}

#Preview("Timer") {
    TimerContentView()
}

#Preview("App state") {
    AppStateContentView()
}
