//
//  ProductAPIRequest.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import Foundation

struct ProductAPIRequest: APIRequest {
    var groupID: Int
    
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "https://tcgcsv.com/20/\(groupID)/products")!)
    }
    
    func decodeResponse(data: Data) throws -> [Product] {
        let decoder = JSONDecoder()
        let productResponse = try decoder.decode(ProductResponse.self, from: data)
        return productResponse.results
    }
}
