//
//  FlashzillaContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 04.05.25.
//

import SwiftUI

struct FlashzillaContentView: View {
    @State private var cards = Array(repeating: Card.example, count: 10)

    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                ZStack {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(card: cards[index], removal: {
                            withAnimation {
                                removeCard(at: index)
                            }
                        })
                        .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
    }

    private func removeCard(at index: Int) {
        cards.remove(at: index)
    }
}

// MARK: - CardView

private struct CardView: View {
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    let card: Card

    var removal: (() -> Void)? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 10)

            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)

                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        // Making it easier to move
        .offset(x: offset.width * 5.0)
        // Starts fading out the card when it is moved more than
        // 50 points left or right
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }

    }
}

// MARK: - Helper View Extension

private extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

// MARK: - Data models

private struct Card {
    let prompt: String
    let answer: String

    static let example = Card(
        prompt: "Who played the 13th Doctor in Doctor Who?",
        answer: "Jodie Whittaker"
    )
}

// MARK: - Previews

// This app is designed to be used in landscape mode.
#Preview(traits: .landscapeRight) {
    FlashzillaContentView()
}
