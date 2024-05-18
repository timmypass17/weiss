//
//  WeissSchwarzService.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation

struct WeissSchwarzService {
    func getGroups(_ category: Category) async throws -> [Group] {
        let request = GroupAPIRequest(category: category)
        let groups: [Group] = try await sendRequest(request)
        return groups
    }
    
    func getProducts(groupID: Int) async throws -> [Card] {
        let request = ProductAPIRequest(groupID: groupID)
        let products: [Card] = try await sendRequest(request)
        var cards = products.filter { $0.isCard }
        
        let prices: [Price] = try await getPrices(groupID: groupID)
        
        for price in prices {
            if let i = cards.firstIndex(where: { $0.id == price.productId }) {
                cards[i].price = price
            }
        }

        return cards
    }
    
    func getPrices(groupID: Int) async throws -> [Price] {
        let priceRequest = PriceAPIRequest(groupID: groupID)
        let prices: [Price] = try await sendRequest(priceRequest)
        return prices
    }
}

enum Category: String {
    case weissSchwarz = "Weiss Schwarz"
    
    var id: Int {
        switch self {
        case .weissSchwarz:
            return 20
        }
    }
}
