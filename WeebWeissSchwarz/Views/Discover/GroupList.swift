//
//  DiscoverView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI
import SwiftData

struct GroupList: View {
    @State var groupListViewModel: GroupListViewModel
    @Environment(\.modelContext) private var modelContext
    var userCategory: UserCategory?
    
    init(category: Category, userCategory: UserCategory?) {
        self._groupListViewModel = State(initialValue: GroupListViewModel(category: category))
        self.userCategory = userCategory
    }
    
    var body: some View {
        @Bindable var groupListViewModel = groupListViewModel
        List {
            Section(groupListViewModel.category.name) {
                ForEach(groupListViewModel.groups) { group in
                    NavigationLink(value: group) {
                        GroupCell(
                            group: group,
                            userGroup: userCategory?.groups.first(where: { $0.groupID == group.id })
                        )
                    }
                }
            }
        }
        .navigationDestination(for: Group.self) { group in
            CardList(
                group: group,
                category: groupListViewModel.category,
                userGroup: userCategory?.groups.first { $0.groupID == group.id }
            )
        }
        .navigationTitle("Discover Sets")
        .toolbar {
            Menu {
                Picker("Select a sorting preference", selection: $groupListViewModel.selectedSort) {
                    ForEach(GroupListViewModel.Sort.allCases) { sort in
                        Text(sort.rawValue.capitalized)
                    }
                }
            } label: {
                Label("Sort", systemImage: "line.3.horizontal.decrease")
            }
        }
    }
    
    func fetchGroup(groupId: Int) -> UserGroup? {
        do {
            let groupPredicate = #Predicate<UserGroup> {
                $0.groupID == groupId
            }
            let descriptor = FetchDescriptor(predicate: groupPredicate)
            let groups: [UserGroup] = try modelContext.fetch(descriptor)
            return groups.first
        } catch {
            print("Error fetching group \(groupId): \(error)")
            return nil
        }
    }
}
// Bindable in view's body: https://developer.apple.com/documentation/swiftui/bindable

//#Preview {
//    NavigationStack {
//        GroupList()
//            .environment(DiscoverViewModel())
//    }
//}


// BAD! Creates destination view (which calls networking code)
//                    NavigationLink {
//                        CardListView(group: group, collectionName: "Weiss Schwarz")
//                    } label: {
//                        DiscoverCell(group: group)
//                    }
