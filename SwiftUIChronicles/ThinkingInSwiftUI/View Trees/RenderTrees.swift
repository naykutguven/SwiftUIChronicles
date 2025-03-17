//
//  RenderTrees.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 17.03.25.
//

import SwiftUI

/// SwiftUI uses the view tree to construct a persistent render tree. **View trees** themselves
/// **are ephemeral/short-lived**: we like to think of view trees as blueprints, since they get constructed
/// and then thrown away over and over again. **Nodes in the persistent render tree**, on
/// the other hand, **have a longer lifetime**: they stay around across view rerenders and are
/// then updated to reflect the current state.
///
/// views when talking about elements in the view tree, and nodes when talking about
/// elements in the render tree.
///
/// >We never deal with the render tree directly, as it’s internal to SwiftUI.
///
/// >Important: The render tree doesn’t actually exist, but it’s a useful model to understand
/// how SwiftUI works. In reality, SwiftUI has something called the attribute graph,
/// which includes more than just the rendered views; it also contains the state
/// and tracks dependencies. Apple calls the nodes in the render tree attributes.
///
/// >Important:
/// >**Lifetime:**
/// >nodes in the render tree have a specific lifetime: from when they’re first rendered,
/// >to when they’re no longer needed for display. **BUT**
/// >the lifetime of nodes in the render tree != their visibility onscreen, not necessarily.
/// >
/// > For example, If we render a large VStack in a scroll view, the render tree will contain
/// >nodes for all subviews of the VStack, no matter if they’re currently onscreen or not.
/// >VStack renders its contents eagerly, as opposed to its LazyVStack counterpart. But
/// >even with a lazy stack, nodes in the render tree will be preserved when they go
/// >oﬀscreen to maintain their state.
/// >
/// > **The bottom line is that nodes in the render tree have a lifetime,
/// but it’s not under our control.**
///
/// For practical purposes, SwiftUI provides three hooks into lifetime events:
/// 1. **onAppear** is executed each time a view appears onscreen. This can be called
/// multiple times for one view even though the backing node in the render tree never went away.
/// 2. **onDisappear** is executed each time a view disappears from the screen. The same logic applies here.
/// 3. **task** is a combination of the two used for asynchronous work. This modifier
/// creates a new task at the point where onAppear would be called, and it cancels
/// this task when onDisappear would be invoked.
struct RenderTrees: View {
    private var greeting: String?

    // View tree:
    // HStack
    //   |_ Image
    //   |
    //   |_ Text?
    //
    // Render tree: when the text is nil
    // HStack
    //   |_ Image
    //
    // Render tree: when the text is "Hello"
    // HStack
    //   |_ Image
    //   |
    //   |_ Text
    //
    // When a node is removed from the render tree,
    // any associated state disappears as well.
    //
    // There’s one more scenario in this example for
    // updating the render tree:
    // we have a non-nil greeting value before and after the update,
    // so the render tree will have the same text node before
    // and after the update as well. However, if the value of greeting
    // has changed, then the string of the text node will be updated.
    //
    // So, 1. adding a node, 2. removing a node, 3. updating a node
    var body: some View {
        HStack {
            Image(systemName: "hand.wave")
            if let g = greeting {
                Text(g)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    RenderTrees()
}
