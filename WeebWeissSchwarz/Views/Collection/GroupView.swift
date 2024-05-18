//
//  GroupView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import SwiftUI

struct GroupView: View {
    var collection: UserCollection
    
    var body: some View {
        Section(collection.name) {
            ForEach(collection.groups.sorted { $0.name < $1.name }) { group in
                NavigationLink {
                    CardListView(userGroup: group)
                        .navigationTitle(group.name)
                } label: {
                    GroupCell(group: group)
                }
            }
        }
    }
}

#Preview {
    GroupView(collection: UserCollection.samples[0])
}
