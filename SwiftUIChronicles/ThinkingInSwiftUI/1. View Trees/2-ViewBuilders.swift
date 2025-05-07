//
//  ViewBuilders.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 14.03.25.
//

import SwiftUI

struct ViewBuilders: View {
    var body: some View {
        // View builders are built on top of Swift's "result builder" feature.
        // The view tree:
        // HStack
        //   |_ Image
        //   |
        //   |_ Text
        //
        // HStack's initializer takes a closure as a parameter and
        // that closure is marked as @ViewBuilder as shown below:
        // `@inlinable public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content)`
        //
        // This allows us to write a number of expressions inside, each of
        // which represents a view.
        //
        // SwiftUI uses view builders in many places. All container views like stacks and grids,
        // as well as modifiers like background and overlay, take a view builder closure
        // to construct their subviews. There are many different overloads/versions of ViewBuilder's
        // `buildBlock` method which enables different kinds of view declarations such as
        // conditional views, single views, tuple views, repeated views and so on.
        //
        // The body property of each view is implicitly marked as @ViewBuilder, as is the body(content:)
        // method of view modifiers. We can also use the @ViewBuilder attribute to mark our own
        // properties and methods as view builders.
        HStack {
            Image(systemName: "hand.wave")
            Text("Hello")
        }

        // HStack
        //   |_ Image
        //   |
        //   |_ Text
        //   |
        //   |_ Spacer
        //   |
        //   |_ Text
        //   |
        //   |_ Image
        HStack(spacing: 20) {
            Image(systemName: "hand.wave")
            Text("Hello")
            Spacer()
            Text("And Goodbye!")
            Image(systemName: "hand.wave")
        }
    }
}

// MARK: - ViewBuilder properties

struct Greeting: View {
    @ViewBuilder var hello: some View {
        Image(systemName: "hand.wave")
        Text("Hello")
    }

    @ViewBuilder var goodbye: some View {
        Text("And Goodbye!")
        Image(systemName: "hand.wave")
    }

    var body: some View {
        // Now, if we take a look at the HStack's view builder closure by cmd + click,
        // we see a TupleView with three elements:
        // "... @ViewBuilder content: () -> TupleView<(some View, Spacer, some View)>"
        // But for the HStack, it is all the same, still has five subviews.
        //
        // The view tree:
        //
        // HStack
        //  |_ TupleView
        //      |_ TupleView
        //          |_ Image
        //          |
        //          |_ Text
        //      |
        //      |_ Spacer
        //      |
        //      |_ TupleView
        //          |_ Text
        //          |
        //          |_ Image
        HStack(spacing: 20) {
            hello
            Spacer()
            goodbye
        }

        // NOTE: - From now on, we won't show tuple views in view trees for the sake of simplicity.
        // Assume the lines between a parent view and its subview(s) as a tuple view.
    }
}

// NOTE: This is a special property of view lists: when a container view
// like the HStack iterates over the view list, nested lists are recursively
// unfolded so that a tree of tuple views turns into a flat list of views.
// This even applies if we were to refactor the hello and bye view builder
// properties into separate views
struct GreetingSeparateViews: View {
    var body: some View {
        HStack(spacing: 20) {
            HelloView()
                .border(Color.blue)
            Spacer()
            ByeView()
                .border(Color.red)

            Group {
                Image(systemName: "hand.wave")
                Text("Hello")
            }
            .border(.blue)
        }
    }
}

struct HelloView: View {
    // This is a view list, so the border modifier is applied to
    // all elements when the list is "unfolded"
    var body: some View {
        Image(systemName: "hand.wave")
        Text("Hello")
    }
}

struct ByeView: View {
    // This is a view list, so the border modifier is applied to
    // all elements when the list is "unfolded"
    var body: some View { // This is a view list
        Text("And Goodbye!")
        Image(systemName: "hand.wave")
    }
}

// MARK: - Exceptional cases with `Group`

/// **IMPORTANT:** When placed as the root view or as the only subview in a `ScrollView`,
/// the group behaves like a `VStack` and the modifiers aren’t applied to each individual view
/// within the group.
struct GroupAsRootView: View {
    var body: some View {
        ScrollView {
            Group {
                Image(systemName: "hand.wave")
                Text("Hello")
            }
            .border(.purple)
        }
    }
}
//  When placing a group within an overlay or background, it behaves like
// an implicit ZStack, presenting another exception to the rule.
struct GroupInsideBackgroundView: View {
    var body: some View {
        ZStack {
            Color.blue
            Group {
                Image(systemName: "hand.wave")
                Text("Hello")
            }
            .border(.purple)
        }
    }
}

// MARK: - Dynamic Content

struct DynamicContent: View {
    @State var showText = true

    // The view tree:
    // HStack
    //  |_ Image
    //  |
    //  |_ Text?
    var body: some View {
        HStack {
            Image(systemName: "hand.wave")
            if showText {
                Text("Hello, World!")
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ViewBuilders()
}

#Preview("GreetingView Separate Views") {
    GreetingSeparateViews()
}

#Preview("Group as root view") {
    GroupAsRootView()
}

#Preview("Group inside background view") {
    GroupInsideBackgroundView()
}

#Preview("Dynamic Content") {
    DynamicContent(showText: true)
}
