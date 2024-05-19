//
//  HomeView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI
import SwiftData

struct CollectionList: View {
    @Query(sort: \UserCollection.name) var userCollection: [UserCollection]
    
    var body: some View {
        List {
            ForEach(userCollection) { collection in
                GroupList(collection: collection)
            }
        }
        .navigationTitle("My Collection")
        .navigationDestination(for: UserGroup.self) { group in
            CardListView(
                cardListViewModel:
                    CardListViewModel(
                        group: Group(id: group.id, name: group.name, abbreviation: "ABBRV", publishedOn: .now),
                        collectionName: group.collection!.name),
                userGroup: group
            )
        }
    }
}

#Preview {
    NavigationStack {
        CollectionList()
            .modelContainer(previewContainer)
    }
}
