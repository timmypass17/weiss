//
//  GroupView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import SwiftUI

struct UserGroupList: View {
    var collection: UserCategory
    
    var body: some View {
        Section(collection.name) {
            ForEach(collection.userGroups.sorted { $0.name < $1.name }) { userGroup in
                NavigationLink(value: userGroup) {
                    UserGroupCell(group: userGroup)
                }
            }
        }
    }
}
