//
//  UserCard.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import Foundation
import SwiftData

@Model
class UserCard {
    @Attribute(.unique) var id: Int
    var imageUrl: String
    var status: CardStatus
    var quantity: Int
    var rarity: Card.Rarity
    
    var group: UserGroup? // TODO: maybe remove nil cause we have cascade delete, not nullify
    
    init(id: Int, imageUrl: String, status: CardStatus, quantity: Int, rarity: Card.Rarity, group: UserGroup? = nil) {
        self.id = id
        self.imageUrl = imageUrl
        self.status = status
        self.quantity = quantity
        self.rarity = rarity
        self.group = group
    }
}

extension UserCard {
    static let samples: [UserCard] = [
        UserCard( // Power
            id: 534213,
            imageUrl: "https://tcgplayer-cdn.tcgplayer.com/product/534213_200w.jpg",
            status: .owned,
            quantity: 1,
            rarity: .c
        ),
        UserCard(
            id: 278798,
            imageUrl: "https://tcgplayer-cdn.tcgplayer.com/product/278798_200w.jpg",
            status: .owned,
            quantity: 1,
            rarity: .r
//            group: UserGroup.samples[0]
        )
    ]
}
