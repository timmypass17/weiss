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
    
    @Relationship(deleteRule: .cascade, inverse: \UserGroup.userCategory)
    var userGroups: [UserGroup] = []
    
    var userCollection: UserCollection?
    
    init(categoryID: Int, name: String, userGroups: [UserGroup] = []) {
        self.categoryID = categoryID
        self.name = name
        self.userGroups = userGroups
    }
}

extension UserCategory {
    static let samples: [UserCategory] = [
        UserCategory(categoryID: 20, name: "Weiss Schwarz", userGroups: UserGroup.samples),
        UserCategory(categoryID: 68, name: "One Piece")
    ]
}
