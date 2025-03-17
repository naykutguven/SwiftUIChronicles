//
//  IdentityView.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 17.03.25.
//

import SwiftUI


// MARK: - Identity

/// SwiftUI uses the identity of a view to determine if it should update a node in the render tree.
///
/// Since view trees in SwiftUI don’t consist of reference types (objects) that have
/// intrinsic identity, SwiftUI assigns identity to views using their position in the view
/// tree. This kind of identity is called _implicit identity_.
struct IdentityView: View {
    @State private var greeting: String?

    /// The view tree of this view:
    ///
    /// HStack
    ///  |
    ///  |_ Image // 0
    ///  |
    ///  |_ ConfitionalContent // 1
    ///    |
    ///    |_ Text // 1. if branch
    ///    |
    ///    |_ Text // 1. else branch
    ///
    /// Each of these views is uniquely identifiable by its position in the tree, so SwiftUI can use
    /// their position to determine if they should be updated or not.
    ///
    /// When the condition changes, the old text will be removed from the render tree,
    /// and a new text will be inserted. This has all kinds of consequences in terms of state,
    /// animations, and transitions, which we’ll discuss later on.
    var body: some View {
        HStack {
            Image(systemName: "hand.wave") // 0
            if let g = greeting { // 1. if branch
                Text(g)
            } else { // 1. else branch
                Text("Hello")
            }
        }
    }
}

// MARK: - Same Identity with optional value

/// The view tree of this view:
///
/// HStack
///  |
///  |_ Image
///  |
///  |_ Text
///
///  The text view itself, as described by its implicit identity (second subview of the HStack),
///  will always be around and unaﬀected by any changes to the value of greeting.
///
/// Views can have explicit identity as well.
/// Either by using the id() view modifier or by using a unique
/// identifier of the underlying data (either by conforming the
/// items to the Identi!able protocol, or by providing a key path to
/// a unique identifier).
///
/// when the value changes, SwiftUI considers
/// this view as a new one and updates the render tree.
/// Meaning, this will remove the previous text node from
/// the render tree and insert a new one.
///
/// >Important:  It’s important to note that an explicit identifier like the one below doesn’t override
/// the view’s implicit identity, but is instead applied on top of it. In other words, SwiftUI won’t be confused
/// by using the same explicit identifiers on multiple views.
/// As we saw, the path of the view is one way to give the implicit identity
/// a concrete form, and we can think of explicit identifiers as “appending to the path.”
struct SameIdentityView: View {
    @State private var greeting: String?

    var body: some View {
        HStack {
            Image(systemName: "hand.wave")
            Text(greeting ?? "Hello")
                .id(greeting == nil)
        }
    }
}

// MARK: - Preview

#Preview {
    IdentityView()
}
