//
//  CardDetailViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/15/24.
//

import Foundation

class CardDetailViewModel: ObservableObject {
    let card: Product
    @Published var isExpandedInfo = true
    @Published var isExpandedPrices = true
    @Published var isExpandedAdditionalPrices = false
    @Published var isExpandedCardText = false
    @Published var selectedStatus: Status = .unowned {
        willSet {
            if case .owned = newValue {
                quantity = 1
            }
        }
    }
    @Published var quantity = 1 {
        willSet {
            if newValue == 0 {
                selectedStatus = .unowned
            }
        }
    }
    
    enum Status: String, CaseIterable, Identifiable {
        case owned, unowned, wishlist
        var id: Self { self }
    }
    
    init(card: Product) {
        self.card = card
    }
}
