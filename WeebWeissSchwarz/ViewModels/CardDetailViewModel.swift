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
    let userCard: UserCard?
    var isExpandedInfo = true
    var isExpandedPrices = true
    var isExpandedAdditionalPrices = false
    var isExpandedCardText = false
    var selectedStatus: UserCard.CardStatus = .unowned {
        willSet {
            if case .owned = newValue {
                quantity = 1
            }
        }
    }
    var quantity = 0
    
    init(card: Card, group: Group, category: Category, userCard: UserCard?) {
        self.card = card
        self.group = group
        self.category = category
        self.userCard = userCard
        
        if let userCard {
            selectedStatus = userCard.cardStatus
            quantity = userCard.quantity
            print(selectedStatus)
        }
    }
}
