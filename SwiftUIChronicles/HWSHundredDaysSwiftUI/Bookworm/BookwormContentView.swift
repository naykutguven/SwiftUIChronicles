//
//  BookwormContentView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 29.04.25.
//

import SwiftData
import SwiftUI

struct BookwormContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]

    @State private var showingAddScreen = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self) { book in
                Text(book.review)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen = true
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
}

// MARK: - Helper views

private struct AddBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 1
    @State private var genre = "Fantasy"
    @State private var review = ""

    private let genres = [
        "Fantasy",
        "Horror",
        "Kids",
        "Mystery",
        "Poetry",
        "Romance",
        "Thriller"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section("Write a review") {
                    TextEditor(text: $review)
                    // SwitUI thinks the whole row in a Form is selectable.
                    // So, when we put multiple buttons in a row, it will
                    // select all of the buttons at once. We can see this in
                    // the print call in RatingView
                    RatingView(rating: $rating, label: "Rate this book")
                }

                Section {
                    Button("Save") {
                        let book = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(book)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

private struct RatingView: View {
    @Binding var rating: Int

    var label = ""
    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow

    var body: some View {
        HStack {
            ForEach(1...maximumRating, id: \.self) { index in
                Button {
                    print("Tapped \(index)")
                    rating = index
                } label: {
                    image(for: index)
                        .foregroundColor(index > rating ? offColor : onColor)
                }
            }
        }
        // This fixes the issue of the whole row being selectable
        // This is insane...
        .buttonStyle(.plain)
    }

    private func image(for index: Int) -> Image {
        if index <= rating {
            return onImage
        } else {
            return offImage ?? onImage
        }
    }
}

private struct EmojiRatingView: View {
    let rating: Int

    var body: some View {
        switch rating {
        case 1:
            return Text("😡")
        case 2:
            return Text("😞")
        case 3:
            return Text("😐")
        case 4:
            return Text("🙂")
        case 5:
            return Text("🤩")
        default:
            return Text("😐")
        }
    }
}

// MARK: - SwiftData models

@Model
final class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int

    init(
        title: String,
        author: String,
        genre: String,
        review: String,
        rating: Int
    ) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}

// MARK: - Previews

#Preview {
    BookwormContentView()
}
