//
//  DiscoverDetailViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import Foundation

@Observable class CardListViewModel {
    var cards: [Card] = []
    var selectedProductType: ProductType = .cards
    var selectedSort: SortType = .number {
        didSet {
            updateProducts()
        }
    }
    var filteredText: String = "" {
        didSet {
            updateProducts()
        }
    }
    var isShowingPrice = true
    var isShowingRarity = true
    var isShowingMissing = true
    var selectedCard: Card? = nil
    var isPresentingInfoSheet = false
    
    @ObservationIgnored
    var cards_: [Card] = []
    let service = WeissSchwarzService()
    
    let group: Group
    let category: Category
    var userGroup: UserGroup?
    
    init(group: Group, category: Category, userGroup: UserGroup?) {
        self.group = group
        self.category = category
        self.userGroup = userGroup

        Task {
            do {
                let products: [Card] = try await service.getProducts(categoryID: category.categoryID, groupID: group.groupID)
                print("[CardListViewModel] getProducts(\(group.groupID)) -> Count: \(products.count)")
                cards_ = products.filter { $0.isCard }
                cards = cards_
            } catch {
                print("Error getting products \(group.groupID): \(error)")
            }
        }
    }

    func updateProducts() {
        if filteredText.isEmpty {
            cards = cards_
        } else {
            cards = cards_.filter { $0.name.localizedStandardContains(filteredText) }
        }
        
        switch selectedSort {
        case .number:
            cards.sort(by: { $0.number < $1.number })
        case .priceAsc:
            cards.sort(by: { $0.price?.marketPrice ?? 0 < $1.price?.marketPrice ?? 0 })
        case .priceDesc:
            cards.sort(by: { $0.price?.marketPrice ?? 0 > $1.price?.marketPrice ?? 0 })
        case .rarity:
            cards.sort(by: { $0.rarity < $1.rarity })
        }
    }
    
}

extension CardListViewModel {
    enum ProductType: String, CaseIterable, Identifiable {
        case cards
        case packs
        var id: Self { self }
    }
    
    enum SortType: String, CaseIterable, Identifiable {
        case number, rarity
        case priceAsc = "Price Ascending"
        case priceDesc = "Price Descending"
        var id: Self { self }
    }
}
