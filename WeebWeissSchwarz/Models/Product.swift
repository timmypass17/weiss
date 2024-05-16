//
//  Product.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import Foundation

struct ProductResponse: Decodable {
    var totalItems: Int
    var results: [Product]
}

struct Product {
    var id: Int
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
    
    enum Rarity: String, CaseIterable {
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

extension Product: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name
        case imageUrl
        case extendedData
    }
}

extension Product: Identifiable {}

extension Product {
    static let samples: [Product] = [
        Product(
            id: 534213,
            name: "Blood Fiend, Power (SP)",
            imageUrl: "https://tcgplayer-cdn.tcgplayer.com/product/534213_200w.jpg",
            price: Price(productId: 534213, lowPrice: 117.76, midPrice: 130.00, highPrice: 188.88, marketPrice: 131.15),
            extendedData: [ExtendedData(name: "Rarity", displayName: "Rarity", value: "Special Rare")])
    ]
}
