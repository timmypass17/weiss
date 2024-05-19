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
    var cardStatus: CardStatus // note: enums doesn't work with predicate. store property as rawValue instead if needed
    var quantity: Int
    var rarity: Card.Rarity

    var group: UserGroup? // TODO: maybe remove nil cause we have cascade delete, not nullify
    
    init(id: Int, imageUrl: String, status: CardStatus, quantity: Int, rarity: Card.Rarity, group: UserGroup? = nil) {
        self.id = id
        self.imageUrl = imageUrl
        self.cardStatus = status
        self.quantity = quantity
        self.rarity = rarity
        self.group = group
    }
}

extension UserCard {
    // Relate a model class to static data (ex. enum) https://developer.apple.com/documentation/swiftdata/defining-data-relationships-with-enumerations-and-model-classes#Relate-a-model-class-to-static-data
    enum CardStatus: String, CaseIterable, Identifiable, Codable {
        case owned, unowned, wishlist
        var id: Self { self }
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
