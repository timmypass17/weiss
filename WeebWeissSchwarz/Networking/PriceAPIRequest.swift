//
//  PriceAPIRequest.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/13/24.
//

import Foundation

struct PriceAPIRequest: APIRequest {
    var categoryID: Int
    var groupID: Int
    
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "https://tcgcsv.com/\(categoryID)/\(groupID)/prices")!)
    }
    
    func decodeResponse(data: Data) throws -> [Price] {
        let decoder = JSONDecoder()
        let priceResponse = try decoder.decode(PriceResponse.self, from: data)
        return priceResponse.results
    }
}
