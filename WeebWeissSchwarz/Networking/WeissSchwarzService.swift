//
//  WeissSchwarzService.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation

struct WeissSchwarzService {
    func getGroups(_ categoryID: CategoryID) async throws -> [Group] {
        let request = GroupAPIRequest(categoryID: categoryID)
        let groups: [Group] = try await sendRequest(request)
        return groups
    }
    
    func getProducts(groupID: Int) async throws -> [Product] {
        let request = ProductAPIRequest(groupID: groupID)
        let products: [Product] = try await sendRequest(request)
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

enum CategoryID: Int {
    case animeID = 20
}
