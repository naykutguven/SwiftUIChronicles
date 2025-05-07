//
//  WordScrambleContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 23.04.25.
//

import SwiftUI

struct WordScrambleContentView: View {
    @State private var usedWords: [String] = []
    @State private var rootWord = ""
    @State private var newWord = ""

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationStack {
            List {
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)

                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(
                errorTitle,
                isPresented: $showingError,
                actions: {
                    Button("OK") { }
                },
                message: {
                    Text(errorMessage)
                }
            )
        }
    }

    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }

        guard isOriginal(word: answer) else {
            wordError(
                title: "Word used already",
                message: "Be more original!"
            )
            return
        }

        guard isPossible(word: answer) else {
            wordError(
                title: "Word not possible",
                message: "You can't spell that word from \(rootWord)."
            )
            return
        }

        guard isReal(word: answer) else {
            wordError(
                title: "Word not recognized",
                message: "You can't just make them up, you know!"
            )
            return
        }
        // this adds a nice little animation to the list.
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }

    private func startGame() {
        guard
            let startWordURL = Bundle.main.url(
                forResource: "start",
                withExtension: "txt"
            ),
            let startWords = try? String(contentsOf: startWordURL)
                .components(separatedBy: "\n")
        else {
            fatalError("Could not load start.txt from bundle")
        }

        rootWord = startWords.randomElement() ?? "silkworm"
    }

    private func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }

        return true
    }

    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        return misspelledRange.location == NSNotFound
    }

    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

// MARK: - Previews

#Preview {
    WordScrambleContentView()
}
