//
//  Collection.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/17/24.
//

import Foundation
import SwiftData

@Model
class UserGroup {
    @Attribute(.unique) var groupID: Int
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \UserCard.group)   // .cascade = delete group -> deletes cards
    var cards: [UserCard] = []
    
    var collection: UserCategory?
    
    var rarityCount: [RarityCount] {
        var rarityFreq: [Card.Rarity: Int] = [:]
        for card in cards {
            rarityFreq[card.rarity, default: 0] += 1
        }
        return rarityFreq.map { RarityCount(rarity: $0.key, count: $0.value) }.sorted(by: { $0.rarity < $1.rarity } )
    }
    
    init(groupID: Int, name: String, cards: [UserCard] = []) {
        self.groupID = groupID
        self.name = name
        self.cards = cards
    }
}

extension UserGroup {
    static let samples: [UserGroup] = [
        UserGroup(groupID: 23307, name: "Chainsaw Man", cards: UserCard.samples),
        UserGroup(groupID: 23249, name: "Spy x Family")
    ]
}


struct RarityCount: Identifiable {
    var id: Card.Rarity { rarity }
    var rarity: Card.Rarity
    var count: Int
}
