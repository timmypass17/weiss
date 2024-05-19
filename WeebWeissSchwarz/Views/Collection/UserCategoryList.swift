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
                group: Group(id: group.groupID, name: group.name, abbreviation: "", publishedOn: .now),
                category: Category(categoryId: group.collection!.categoryID, name: group.collection!.name, modifiedOn: "", popularity: 0))
        }
    }
}

//#Preview {
//    NavigationStack {
//        UserCategoryList()
//            .modelContainer(previewContainer)
//    }
//}
