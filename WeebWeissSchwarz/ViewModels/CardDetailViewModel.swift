//
//  CardDetailViewModel.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/15/24.
//

import Foundation

@Observable class CardDetailViewModel {
    let card: Card // TODO: Maybe make card have reference to group, and group have reference to category
    let group: Group
    let category: Category
    var isExpandedInfo = true
    var isExpandedPrices = true
    var isExpandedAdditionalPrices = false
    var isExpandedCardText = false
    var selectedStatus: CardStatus = .unowned {
        willSet {
            if case .owned = newValue {
                quantity = 1
            }
        }
    }
    var quantity = 1 {
        willSet {
            if newValue == 0 {
                selectedStatus = .unowned
            }
        }
    }
    
    init(card: Card, group: Group, category: Category) {
        self.card = card
        self.group = group
        self.category = category
    }
}

// Relate a model class to static data (ex. enum) https://developer.apple.com/documentation/swiftdata/defining-data-relationships-with-enumerations-and-model-classes#Relate-a-model-class-to-static-data
enum CardStatus: String, CaseIterable, Identifiable, Codable {
    case owned, unowned, wishlist
    var id: Self { self }
}
