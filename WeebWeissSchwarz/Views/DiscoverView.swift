//
//  DiscoverView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        List {
            Section("Weiss Schwarz") {
                ForEach(discoverViewModel.groups) { group in
                    NavigationLink {
                        CardListView(groupID: group.id)
                            .navigationTitle(group.name)
                    } label: {
                        DiscoverCell(group: group)
                    }

                }
            }
        }
        .navigationTitle("Discover")
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
}

#Preview {
    DiscoverView()
}
