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

    // A simple way would be @Query(sort: \Book.rating, order: .reverse)
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) private var books: [Book]

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
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
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

    private func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
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

private struct BookDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showingDeleteAlert = false

    let book: Book

    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()

                Text(book.genre.uppercased())
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: -5, y: -5)
            }

            Text(book.author)
                .font(.title)
                .foregroundStyle(.secondary)

            Text(book.review)
                .padding()

            // Constant because we don't want to change the rating
            RatingView(rating: .constant(book.rating))
                .font(.largeTitle)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Delete", systemImage: "trash") {
                    showingDeleteAlert = true
                }
            }
        }
    }

    private func deleteBook() {
        modelContext.delete(book)
        dismiss()
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

#Preview("Book detail") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    if let container = try? ModelContainer(for: Book.self, configurations: config) {
        let exampleBook = Book(
            title: "Example",
            author: "Author",
            genre: "Fantasy",
            review: "Great book!",
            rating: 5
        )

        BookDetailView(book: exampleBook)
            .modelContainer(container)
    }
}
