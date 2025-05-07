//
//  Prospect.swift
//  SwiftUIChronicles
//
//  Created by Aykut Güven on 03.05.25.
//

import Foundation
import SwiftData

@Model
final class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool

    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
