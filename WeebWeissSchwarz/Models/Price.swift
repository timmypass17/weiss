//
//  Prices.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/13/24.
//

import Foundation

struct PriceResponse: Decodable {
    var results: [Price]
}

struct Price: Decodable {
    var productId: Int
    var lowPrice: Float?
    var midPrice: Float?
    var highPrice: Float?
    var marketPrice: Float?
    
    var data: [TCGPrice] {
        var prices: [TCGPrice] = []
        if let lowPrice {
            prices.append(TCGPrice(name: "Low", price: lowPrice))
        }
        if let midPrice {
            prices.append(TCGPrice(name: "Mid", price: midPrice))
        }
        if let highPrice {
            prices.append(TCGPrice(name: "High", price: highPrice))
        }
        return prices
    }
    
    struct TCGPrice: Identifiable {
        var id: String { name }
        let name: String
        let price: Float
    }
}

extension Float {
    var currencyString: String {
        // 1234.5678 -> $1,234.57
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let formattedCurrency = formatter.string(from: self as NSNumber) {
            return formattedCurrency
        }
        
        return "N/A"
    }
}
