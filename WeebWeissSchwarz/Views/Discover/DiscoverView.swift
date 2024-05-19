//
//  DiscoverView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Environment(DiscoverViewModel.self) var discoverViewModel: DiscoverViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserCollection.name) var userCollection: [UserCollection]

    var body: some View {
        @Bindable var discoverViewModel = discoverViewModel
        List {
            Section("Weiss Schwarz") {
                ForEach(discoverViewModel.groups) { group in
                    NavigationLink(value: group) {
                        DiscoverCell(
                            group: group,
                            userGroup: userCollection
                                .first(where: { $0.name == "Weiss Schwarz"})?
                                .groups.first(where: { $0.id == group.id })
                            
                        )
                    }
                }
            }
        }
        .navigationDestination(for: Group.self) { group in
            CardListView(
                cardListViewModel: CardListViewModel(group: group, collectionName: "Weiss Schwarz"),
                userGroup: fetchGroup(groupId: group.id)
            )
        }
        .navigationTitle("Discover Sets")
        .toolbar {
            Menu {
                Picker("Select a sorting preference", selection: $discoverViewModel.selectedSort) {
                    ForEach(DiscoverViewModel.Sort.allCases) { sort in
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
                $0.id == groupId
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

#Preview {
    NavigationStack {
        DiscoverView()
            .environment(DiscoverViewModel())
    }
}


// BAD! Creates destination view (which calls networking code)
//                    NavigationLink {
//                        CardListView(group: group, collectionName: "Weiss Schwarz")
//                    } label: {
//                        DiscoverCell(group: group)
//                    }
