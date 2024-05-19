//
//  CategoryListViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/18/24.
//

import Foundation

@Observable class CategoryListViewModel {
    var categories: [Category] = []
    
    var service = WeissSchwarzService()
    
    init() {
        Task {
            do {
                categories = try await service.getCategories()
            } catch {
                print("[CategoryListViewModel] Error getting categories: \(error)")
            }
        }
    }
}
