//
//  Transactions.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 16.04.25.
//

import SwiftUI

/// Both implicit and explicit animations use a `Transaction` under the hood.
/// Every view update that is triggered by a state change is wrapped inside
/// a transaction. We can think of transactions as constructs to transfer
/// information about how a view is supposed to change. By default, a transaction's
/// animation is nil.
///
/// The `.withAnimation` modifier creates a transaction implicitly and sets the
/// `animation` property of it. Here is an example of `Transaction` equivalent
/// of `withAnimation` modifier using `withTransaction`.
///
/// We could also use `.transaction` modifier like the second circle below.
///
/// - Important: This one behaves like the deprecated `.animation(_:)` modifier
/// without the `value` parameter. One important difference is that there is no
/// animation in the first circle when the second circle is tapped because the
/// `.transaction` modifier is not applied. The `.transaction` modifier
/// is passed down the view tree. That is why we see the second circle animated
/// when the first circle is tapped.
///
/// We know that both implicit and explicit animations set the animation property
/// of the current transaction. So, there must be precedence between the two.
/// THe implicit animation takes precedence over the explicit animation. The
/// implicit animation will be executed later while evaluating the view tree,
/// thus overriding any explicit animation that might have been set at the start
/// of the state change.
///
/// - Tip: `Transaction`s have another useful property called `disablesAnimations`
/// when set to `true`, it prevents implicit animations from overriding the
/// transaction's animation.
///
/// We can also remove the current animation by writing
/// `.transaction { $0.animation = nil }`.
///
/// As of iOS 17.0, we can use `TransactionKey` protocol to extend transactions
/// through custom keys - just like we do with `EnvironmentKey` protocol. This
/// allows us to attach state to a transaction and read it later on while the
/// transaction is processed. For example, we could add the source of a change
/// to the transaction (whether it originated on the server or the client) and
/// choose our implicit animation based on this value.
struct TransactionsContentView: View {
    @State private var flag = false

    var body: some View {
        Circle()
            .fill(.orange.gradient)
            .frame(width: flag ? 100: 50)
            .onTapGesture {
                let t = Transaction(animation: .default)
                withTransaction(t) {
                    flag.toggle()
                }
            }

        Circle()
            .fill(.red.gradient)
            .frame(width: flag ? 100: 50)
            .transaction { t in
                t.animation = .default
            }
            .onTapGesture {
                flag.toggle()
            }
    }
}

// MARK: - Completion Handlers

/// As of iOS 17.0, we can set completion handlers for transactions - either
/// directly when using the explicit `withAnimation`, or by using
/// `.addAnimationCompletion` within the closure of a `.transaction` modifier.
/// - Important: The first completion handler is only called once when the transaction
/// because SwiftUI seems to track deoendencies of the `.transaction` closure.
/// Since this closure doesn't depend on any state, it doesn't get executed again.
/// We can mitigate this by using the `.transaction(value:_ transform:)` modifier
/// instead.
struct CompletionHandlerTransactionContentView: View {
    @State private var flag = false

    var body: some View {
        VStack {
            Button("Animate!") { flag.toggle() }
            Circle()
                .fill(flag ? .green : .red)
                .frame(width: 50, height: 50)
                .animation(.default, value: flag)
                .transaction {
                    $0.addAnimationCompletion { print("Done once!") }
                }

            Circle()
                .fill(flag ? .green : .red)
                .frame(width: 50, height: 50)
                .animation(.default, value: flag)
                .transaction(value: flag) {
                    $0.addAnimationCompletion { print("Done again!") }
                }
        }
    }
}

// MARK: - Previews

#Preview {
    TransactionsContentView()
    CompletionHandlerTransactionContentView()
}
