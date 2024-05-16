//
//  DiscoverViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation

// Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
@MainActor
class DiscoverViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var selectedSort: Sort = .newest {
        willSet {
            sortValueDidChange(newValue)
        }
    }

    let service = WeissSchwarzService()
    
    enum Sort: String, CaseIterable, Identifiable {
        case newest, name, abbreviation
        var id: Self { self }
    }
    
    init() {
        Task {
            groups = (try? await service.getGroups(.animeID)) ?? []
            sortValueDidChange(.newest) // TODO: use user prefrence
        }
    }
    
    func sortValueDidChange(_ sort: Sort) {
        switch sort {
        case .name:
            groups.sort { $0.name < $1.name }
        case .newest:
            groups.sort { $0.publishedOn > $1.publishedOn }
        case .abbreviation:
            groups.sort { $0.abbreviation < $1.abbreviation }

        }
    }
}

