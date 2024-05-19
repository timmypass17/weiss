//
//  GroupView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import SwiftUI

struct GroupList: View {
    var collection: UserCollection
    
    var body: some View {
        Section(collection.name) {
            ForEach(collection.groups.sorted { $0.name < $1.name }) { userGroup in
                NavigationLink(value: userGroup) {
                    GroupCell(group: userGroup)
                }
            }
        }
    }
}
