//
//  HomeView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI
import SwiftData

struct UserCategoryList: View {
    @Query(sort: \UserCategory.name) var userCollection: [UserCategory]
    
    var body: some View {
        List {
            ForEach(userCollection) { collection in
                UserGroupList(collection: collection)
            }
        }
        .navigationTitle("My Collection")
        .navigationDestination(for: UserGroup.self) { group in
//            CardListView(
//                cardListViewModel:
//                    CardListViewModel(
//                        group: Group(id: group.id, name: group.name, abbreviation: "ABBRV", publishedOn: .now),
//                        catgory: group.collection!.name),
//                userGroup: group
//            )
        }
    }
}

#Preview {
    NavigationStack {
        UserCategoryList()
            .modelContainer(previewContainer)
    }
}
