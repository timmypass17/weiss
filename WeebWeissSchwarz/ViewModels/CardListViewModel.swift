//
//  DiscoverDetailViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import Foundation

@MainActor
class CardListViewModel: ObservableObject {
    @Published var cards: [Product] = []
    @Published var selectedProductType: ProductType = .cards
    @Published var selectedSort: SortType = .number {
        didSet {
            updateProducts()
        }
    }
    @Published var filteredText: String = "" {
        didSet {
            updateProducts()
        }
    }
    @Published var isShowingPrice: Bool = false
    @Published var isShowingOwned: Bool = false
    @Published var selectedCard: Product? = nil
    
    var cards_: [Product] = []
    let service = WeissSchwarzService()
    
    init(groupID: Int) {
        Task {
            do {
                let products: [Product] = try await service.getProducts(groupID: groupID)
                cards_ = products.filter { $0.isCard }
                cards = cards_
            } catch {
                print("Error getting products: \(error)")
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
