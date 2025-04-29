//
//  SwiftUIChroniclesApp.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 13.03.25.
//

import SwiftData
import SwiftUI

@main
struct SwiftUIChroniclesApp: App {
    var body: some Scene {
        WindowGroup {
            SwiftDataTipsContentView()
        }
        .modelContainer(for: HWSSwiftDataUser.self)
//        .modelContainer(for: Book.self)
//        Just added as an example
//        .modelContainer(for: Student.self)
    }
}
