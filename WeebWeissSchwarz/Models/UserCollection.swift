//
//  UserCollection.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import Foundation
import SwiftData

@Model
class UserCollection {
    @Attribute(.unique) var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \UserGroup.collection)
    var groups: [UserGroup] = []
    
    init(name: String, groups: [UserGroup] = []) {
        self.name = name
        self.groups = groups
    }
}

extension UserCollection {
    static let samples: [UserCollection] = [
        UserCollection(name: "Weiss Schwarz", groups: UserGroup.samples),
        UserCollection(name: "One Piece")
    ]
}
