//
//  MatchedGeometryEffect.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 19.04.25.
//

import SwiftUI

/// `matchedGeometryEffect` is a modifier that is used give one or more views
/// (the targets) the same position, size, or frame (position and size) as another
/// view (the source). This works by measuring the size and position of the
/// source view and then proposing the same size to the target views, as well as
/// setting oﬀsets on them. The source and target views belonging to one matched
/// geometry group can be located anywhere in the view tree and are identified
/// using a namespace and a secondary `Hashable` identifier.
///
/// In the example below, we implement the highlighting ellipse using the matched
/// geometry effect instead of manually propagating anchors.
///
/// - Warning: Within a geometry group, **only one view is allowed to be the
/// source for the group.** The `isSource` parameter is true by default, so we
/// explicitly have to specify false for the ellipse in the overlay, since the
/// matching should happen from the button to the ellipse.
/// This is one thing I don't like about the API - devs can easily overlook this
/// and forget to set the `isSource` parameter to false. This is a bit
/// counterintuitive.
///
/// - Important: It’s entirely up to the frame’s subview to decide what to do
/// with that proposed size. For example, if the target view is a fixed-size view
/// (e.g. a non-resizable image or another fixed frame), the matched geometry
/// eﬀect won’t influence the target view’s size.
struct MatchedGeometryEffectContentView: View {
    @Namespace var namespace
    let groupID = "highlight" // could be an `Int` or a `UUID`

    var body: some View {
        VStack {
            Button("Sign Up") {}
            Button("Log In") {}
                .matchedGeometryEffect(id: groupID, in: namespace)
        }
        .overlay {
            Ellipse()
                .strokeBorder(Color.red, lineWidth: 1)
                .padding(-5)
                .matchedGeometryEffect(id: groupID, in: namespace, isSource: false)

        }
    }
}

// MARK: - Matched Geometry Effect and Transitions

/// Matched geometry eﬀects are applied before a view is inserted and after it
/// has been removed, similar to how the active state of a transition is
/// applied to a view that’s being inserted or removed. This allows us to
/// create smooth transitions from one view to another with very little code.
///
/// - Important: When we insert a new view that’s part of a geometry group into
/// the view hierarchy, its initial geometry is computed as if the `isSource`
/// parameter on this view is set to false, i.e. the view’s geometry is matched
/// to the source view that’s in the view tree before the state change. When we
/// remove a view from the view tree, its final geometry is matched to the
/// source view that’s going to be in the view tree after the state change.
///
/// There are two parts to this animation:
/// 1. First, the matched geometry eﬀect takes care of the position and size,
/// and the default transition (opacity) blends between the two views. In other
/// words, during the transition, both views are onscreen. When we change hero
/// from false to true, the first view is inserted with an opacity of 0 and a
/// frame that matches the second view (which was the source view of the
/// geometry group before the state change). During that transition, the first
/// view animates from that matched initial position toward its final position
/// while fading in.
/// 2. At the same time, the second view (that got removed) fades
/// out and animates from its former position before the state change to the
/// position it would occupy after the state change, now that it’s matched to
/// the newly inserted source view.
///
/// - Important: The order of the modifiers is both crucial and easy to get wrong.
///
/// Matched geometry effects can be used in creative animations with views that
/// remain in the view hierarchy. We can insert or remove views from a geometry
/// group by changing their namespaces or identifiers.
struct MatchedGeometryEffectTransitionContentView: View {
    @State private var hero = false
    @State private var animationFlag = false

    @Namespace var namespace

    var body: some View {
        let circle = Circle().fill(Color.green)
        ZStack {
            if hero {
                circle
                    .matchedGeometryEffect(id: "image", in: namespace)
            } else {
                circle
                // When we apply different colors, it looks a bit weird idk.
//                    .fill(Color.red)
                    .matchedGeometryEffect(id: "image", in: namespace)
                    .frame(width: 30, height: 30)
            }
        }
        .onTapGesture {
            withAnimation(.default) { hero.toggle() }
        }

        Circle()
            .fill(animationFlag ? Color.green : Color.red)
            .frame(width: animationFlag ? .infinity : 30)
            .onTapGesture {
                withAnimation { animationFlag.toggle() }
            }
    }
}

// MARK: - Previews

#Preview {
    MatchedGeometryEffectContentView()
}

#Preview("Matched Geometry Effect and Transitions") {
    MatchedGeometryEffectTransitionContentView()
}
