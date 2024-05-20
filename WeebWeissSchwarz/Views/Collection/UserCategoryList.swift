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
    
    var body: some View {
        List {
            ForEach(userCategories) { collection in
                UserGroupList(collection: collection)
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
    }
}

//#Preview {
//    NavigationStack {
//        UserCategoryList()
//            .modelContainer(previewContainer)
//    }
//}
