//
//  WeissSchwarzService.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation

struct WeissSchwarzService {
    func getCategories() async throws -> [Category] {
        let request = CategoryAPIRequest()
        let categories: [Category] = try await sendRequest(request)
        return categories
    }
    
    func getGroups(_ category: Category) async throws -> [Group] {
        let request = GroupAPIRequest(category: category)
        let groups: [Group] = try await sendRequest(request)
        return groups
    }
    
    func getProducts(categoryID: Int, groupID: Int) async throws -> [Card] {
        let request = ProductAPIRequest(categoryID: categoryID, groupID: groupID)
        let products: [Card] = try await sendRequest(request)
        var cards = products.filter { $0.isCard }
        
        let prices: [Price] = try await getPrices(categoryID: categoryID, groupID: groupID)
        
        for price in prices {
            if let i = cards.firstIndex(where: { $0.id == price.productId }) {
                cards[i].price = price
            }
        }

        return cards
    }
    
    func getPrices(categoryID: Int, groupID: Int) async throws -> [Price] {
        let priceRequest = PriceAPIRequest(categoryID: categoryID, groupID: groupID)
        let prices: [Price] = try await sendRequest(priceRequest)
        return prices
    }
}
