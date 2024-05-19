//
//  CategoryList.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/18/24.
//

import SwiftUI

struct CategoryList: View {
   @State var categoryListViewModel = CategoryListViewModel()
    var userCategories: [UserCategory]
    
    var body: some View {
        List {
            Section("TCGPlayer") {
                ForEach(categoryListViewModel.categories) { category in
                    NavigationLink(value: category) {
                        Text(category.name)
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .navigationDestination(for: Category.self) { category in
            GroupList(category: category, userCategories: userCategories)
        }
    }
}

//#Preview {
//    NavigationStack {
//        CategoryList()
//    }
//}
