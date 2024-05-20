//
//  Product.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import Foundation
import SwiftUI

struct ProductResponse: Decodable {
    var totalItems: Int
    var results: [Card]
}

struct Card {
    var productID: Int
    var groupID: Int
    // cateogryId?
    var name: String
    var imageUrl: String
    var price: Price?
    var extendedData: [ExtendedData]
    
    var isCard: Bool {
        return !extendedData.contains { $0.name == "UPC" }
    }
    
    var number: String {
        return extendedData.first(where: { $0.name == "Number" })?.value ?? ""
    }
    
    var rarity: Rarity {
        if let rarityString = extendedData.first(where: { $0.name == "Rarity"})?.value,
           let rarity = Rarity(rawValue: rarityString) {
            return rarity
        }
        
        return .unknown
    }
    
    var cardText: String {
        return extendedData.first(where: { $0.name == "CardText" })?.value ?? ""
    }
    
    enum Rarity: String, CaseIterable, Codable {
        case unknown = "N/A"
        case pr = "Promo"
        case td = "Trial Deck"
        case cc = "Climax Common"
        case cr = "Climax Rare"
        case c = "Common"
        case u = "Uncommon"
        case r = "Rare"
        case rr = "Double Rare"
        case sr = "Super Rare"
        case rrr = "Triple Rare"
        case sp = "Special Rare"
        
        private var sortOrder: Int {
            return Rarity.allCases.firstIndex(of: self)!
        }
        
        static func <(lhs: Rarity, rhs: Rarity) -> Bool {
            return lhs.sortOrder < rhs.sortOrder
        }

        var abbreviation: String {
            switch self {
            case .unknown:
                return "N/A"
            case .pr:
                return "PR"
            case .td:
                return "TD"
            case .cc:
                return "CC"
            case .cr:
                return "CR"
            case .c:
                return "C"
            case .u:
                return "U"
            case .r:
                return "R"
            case .rr:
                return "RR"
            case .sr:
                return "SR"
            case .rrr:
                return "RRR"
            case .sp:
                return "SP"
            }
        }
        
        var color: Color {
            switch self {
            case .unknown:
                return .secondary
            case .pr:
                return Color(red: 1.0, green: 0.84, blue: 0.0)
            case .td:
                return Color(red: 0.68, green: 0.85, blue: 0.9)
            case .cc:
                return Color(red: 0.5, green: 0.5, blue: 0.5)
            case .cr:
                return Color(red: 0.5, green: 0.5, blue: 0.5)
            case .c:
                return Color(red: 0.5, green: 0.5, blue: 0.5)
            case .u:
                return .green
            case .r:
                return .blue
            case .rr:
                return .blue
            case .sr:
                return .purple
            case .rrr:
                return .orange
            case .sp:
                return .red
            }
        }
    }
}

extension Card: Decodable {
    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case groupID = "groupId"
        case name
        case imageUrl
        case extendedData
    }
}

struct ExtendedData: Decodable {
    var id = UUID()
    var name: String
    var displayName: String
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case displayName
        case value
    }
}

extension ExtendedData: Identifiable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.value = try container.decode(String.self, forKey: .value)
//            .replacingOccurrences(of: "<br>", with: "\n")r
    }
}


extension Card: Identifiable {
    var id: Int { productID }
}

extension Card {
    static let samples: [Card] = [
        Card(
            productID: 534213,
            groupID: 23307,
            name: "Blood Fiend, Power (SP)",
            imageUrl: "https://tcgplayer-cdn.tcgplayer.com/product/534213_200w.jpg",
            price: Price(productId: 534213, lowPrice: 117.76, midPrice: 130.00, highPrice: 188.88, marketPrice: 131.15),
            extendedData: [ExtendedData(name: "Rarity", displayName: "Rarity", value: "Special Rare")])
    ]
}
