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
        .navigationDestination(for: UserGroup.self) { userGroup in
            CardList(
                group: Group(groupID: userGroup.groupID, name: userGroup.name, abbreviation: userGroup.abbreviation, publishedOn: .now),
                category: Category(categoryID: userGroup.userCategory!.categoryID, name: userGroup.userCategory!.name, modifiedOn: "", popularity: 0),
                userGroup: userCategories
                    .first { $0.categoryID == userGroup.userCategory?.categoryID }?.userGroups
                    .first { $0.groupID == userGroup.groupID }
            )
        }
    }
}

#Preview {
    NavigationStack {
        UserCategoryList(userCategories: UserCollection.sample.userCategories, removeUserCategory: { _ in })
            .modelContainer(previewContainer)
    }
}
