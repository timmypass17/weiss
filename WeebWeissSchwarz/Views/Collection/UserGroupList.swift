//
//  GroupView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import SwiftUI

struct UserGroupList: View {
    var userCategory: UserCategory
    @Environment(\.modelContext) private var modelContext
    var removeUserCategory: (UserCategory) -> Void
    
    var body: some View {
        Section(userCategory.name) {
            ForEach(userCategory.userGroups.sorted { $0.name < $1.name }) { userGroup in
                NavigationLink(value: userGroup) {
                    UserGroupCell(group: userGroup)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        removeUserGroup(userGroup)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    func removeUserGroup(_ userGroup: UserGroup) {
        guard let index = userCategory.userGroups.firstIndex(where: { $0.groupID == userGroup.groupID }) else { return }
        userCategory.userGroups.remove(at: index)
        modelContext.delete(userGroup)
        
        if userCategory.userGroups.isEmpty {
            removeUserCategory(userCategory)
        }
    }
}
