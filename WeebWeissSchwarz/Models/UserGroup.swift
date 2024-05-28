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
    var abbreviation: String
    
    @Relationship(deleteRule: .cascade, inverse: \UserCard.group)   // .cascade = delete group -> deletes cards
    var userCards: [UserCard] = [] // note: deleting userCard from array also removes that card's group reference
    
    var userCategory: UserCategory?
    
    init(groupID: Int, name: String, abbreviation: String, userCards: [UserCard] = []) {
        self.groupID = groupID
        self.name = name
        self.userCards = userCards
        self.abbreviation = abbreviation
    }
}

extension UserGroup {
    var rarityCount: [Card.Rarity: Int] {
        var rarityFreq: [Card.Rarity: Int] = [:]
        let ownedCards = userCards.filter { $0.cardStatus == .owned }
        for card in ownedCards {
            rarityFreq[card.rarity, default: 0] += 1
        }
        return rarityFreq
    }
    
    var ownedCount: Int {
        // note: modifying array's property doesn't recalculate. Inserting and deleting does.
        print("Computing owned count")
        return userCards.filter { $0.cardStatus == .owned }.count
    }
    
    func getNetWorth(cards: [Card]) -> Double {
        var total: Double = 0.0
        let cardIDs: Set = Set(userCards.map { $0.cardID })
        for card in cards {
            if cardIDs.contains(card.id),
               let price = card.price?.marketPrice{
                    total += Double(price)
            }
        }
        return total
    }
}

extension UserGroup {
    static let samples: [UserGroup] = [
        UserGroup(groupID: 23307, name: "Chainsaw Man", abbreviation: "CSM", userCards: UserCard.samples),
        UserGroup(groupID: 23249, name: "Spy x Family", abbreviation: "SPY")
    ]
}


struct RarityCount: Identifiable {
    var id: Card.Rarity { rarity }
    var rarity: Card.Rarity
    var count: Int
}
