//
//  UserCollection.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/21/24.
//

import Foundation
import SwiftData

@Model
class UserCollection {
    @Relationship(deleteRule: .cascade, inverse: \UserCategory.userCollection)
    var userCategories: [UserCategory]
    
    init(userCategories: [UserCategory] = []) {
        self.userCategories = userCategories
    }
}

extension UserCollection {
    static let sample = UserCollection(userCategories: UserCategory.samples)
}
