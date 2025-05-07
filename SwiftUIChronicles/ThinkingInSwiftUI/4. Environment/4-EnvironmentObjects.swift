//
//  EnvironmentObjects.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 14.04.25.
//

import SwiftUI

/// We can use the environment mechanism to pass around not just values, but also
/// objects. This is a great way to inject dependencies into our views.
struct EnvironmentObjectsContentView: View {
    var body: some View {
        MyNestedView()
            .padding()
            .environment(UserModel())
    }
}

// MARK: - iOS 17.0 and above

/// As of iOS 17.0, we can use `@Observable` to create an environment object.
/// The propoerty should be declared with `@Environment` property wrapper where
/// it is used, just like we did previously with other environment values.
///
/// The neat thing about injecting objects through the environment is that If
/// some view further up in the hierarchy has set a user model in the environment,
/// we’ll be able to access it here without having to pass the object through
/// all the levels of the view tree – an issue we have in UIKit which may cause
/// a lot of boilerplate code. If the object hasn’t been set in the environment,
/// the `userModel` property will be nil.
/// - Note: Optional environment objects are
/// available in iOS 17.0 and above.
/// - Important: If an environment object is a non-optional type, we have to
/// rely on this object being present in the environment. Otherwise, the app will
/// crash when we try to access the environment property.
///
/// ## Prior to iOS 17.0
///
/// Prior to iOS 17, we have to use two diﬀerent APIs: the `@EnvironmentObject`
/// property wrapper is used to read an object from the environment, and the
/// `environmentObject` modifier is used to set an object in the environment.
/// These APIs also rely on the type of the object as the key. However, the object
/// has to conform to the `ObservableObject` protocol.
///
/// >Important: When using `@EnvironmentObject`, there’s no way to declare
/// >the property with an optional type. The code will crash if no object of the
/// >specified type has been set in the environment and we access the
/// >`@EnvironmentObject` property. A helpful technique is to at least bundle up
/// >all our environment object setters into a single helper method:
/// >```swift
/// >extension View {
/// >    func injectDependencies() -> some View {
/// >        environmentObject(UserModel())
/// >            .environmentObject(Database())
/// >    }
/// >}
/// >```
/// - Note: Environment objects work well with subclassing.
@Observable final class UserModel {
    var name = "Bob Ross"
}

struct MyNestedView: View {
    @Environment(\.userModel) var userModel: UserModel?
    var body: some View {
        Text(userModel?.name ?? "default name")
    }
}

enum UserModelKey: EnvironmentKey {
    static var defaultValue: UserModel? { nil }
}

extension EnvironmentValues {
    var userModel: UserModel? {
        get { self[UserModelKey.self] }
        set { self[UserModelKey.self] = newValue }
    }
}

// MARK: - Previews

#Preview {
    EnvironmentObjectsContentView()
        .environment(\.userModel, UserModel())
}
