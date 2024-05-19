//
//  UserCollection.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import Foundation
import SwiftData

@Model
class UserCategory {
    @Attribute(.unique) var categoryID: Int
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \UserGroup.collection)
    var groups: [UserGroup] = []
    
    init(categoryID: Int, name: String, groups: [UserGroup] = []) {
        self.categoryID = categoryID
        self.name = name
        self.groups = groups
    }
}

extension UserCategory {
    static let samples: [UserCategory] = [
        UserCategory(categoryID: 20, name: "Weiss Schwarz", groups: UserGroup.samples),
        UserCategory(categoryID: 68, name: "One Piece")
    ]
}
