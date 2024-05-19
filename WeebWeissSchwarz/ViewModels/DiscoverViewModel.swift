//
//  DiscoverViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation
import SwiftUI


@Observable class GroupListViewModel {
    var groups: [Group] = []
    var selectedSort: Sort = .newest {
        willSet {
            sortValueDidChange(newValue)
        }
    }
    var category: Category
    
    let service = WeissSchwarzService()
    
    enum Sort: String, CaseIterable, Identifiable {
        case newest, name, abbreviation
        var id: Self { self }
    }
    
    init(category: Category) {
        self.category = category
        Task {
            do {
                groups = try await service.getGroups(category)
                print("[DiscoverViewModel] getGroups() -> Count: \(groups.count)")
                sortValueDidChange(.newest) // TODO: use user prefrence
                
            } catch {
                print("Error fetching groups: \(error)")
            }
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

