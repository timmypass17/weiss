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
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            ForEach(userCollection) { collection in
                GroupView(collection: collection)
            }
        }
        .navigationTitle("My Collection")
    }
}

#Preview {
    NavigationStack {
        CollectionList()
            .modelContainer(previewContainer)
    }
}
