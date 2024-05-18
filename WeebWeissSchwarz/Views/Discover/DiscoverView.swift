//
//  DiscoverView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI

struct DiscoverView: View {
    @Environment(DiscoverViewModel.self) var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        @Bindable var discoverViewModel = discoverViewModel
        List {
            Section("Weiss Schwarz") {
                ForEach(discoverViewModel.groups) { group in
                    NavigationLink(value: group) {
                        DiscoverCell(group: group)
                    }
                    
                    // BAD! Creates destination view (which calls networking code)
//                    NavigationLink {
//                        CardListView(group: group, collectionName: "Weiss Schwarz")
//                    } label: {
//                        DiscoverCell(group: group)
//                    }

                }
            }
        }
        .navigationDestination(for: Group.self) { group in
            CardListView(group: group, collectionName: "Weiss Schwarz")
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
}
// Bindable in view's body: https://developer.apple.com/documentation/swiftui/bindable

#Preview {
    NavigationStack {
        DiscoverView()
            .environment(DiscoverViewModel())
    }
}
