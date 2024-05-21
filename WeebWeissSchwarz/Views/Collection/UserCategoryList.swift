//
//  HomeView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI
import SwiftData

struct UserCategoryList: View {
    var userCategories: [UserCategory]
    var removeUserCategory: (UserCategory) -> Void

    var body: some View {
        List {
            ForEach(userCategories) { userCategory in
                UserGroupList(userCategory: userCategory, removeUserCategory: removeUserCategory)
            }
        }
        .navigationTitle("My Collection")
        .navigationDestination(for: UserGroup.self) { group in
            CardList(
                group: Group(groupID: group.groupID, name: group.name, abbreviation: "", publishedOn: .now),
                category: Category(categoryID: group.userCategory!.categoryID, name: group.userCategory!.name, modifiedOn: "", popularity: 0),
                userGroup: userCategories
                    .first { $0.categoryID == group.userCategory?.categoryID }?.userGroups
                    .first { $0.groupID == group.groupID }
            )
        }
        // TODO: Test swipe to delete group (ex. Chainsaw Man)
    }
}

#Preview {
    NavigationStack {
        UserCategoryList(userCategories: UserCollection.sample.userCategories, removeUserCategory: { _ in })
            .modelContainer(previewContainer)
    }
}
