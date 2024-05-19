//
//  CategoryAPIRequest.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/18/24.
//

import Foundation

struct CategoryAPIRequest: APIRequest {
    
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "https://tcgcsv.com/categories")!)
    }
    
    func decodeResponse(data: Data) throws -> [Category] {
        let decoder = JSONDecoder()
        let categoryResponse = try decoder.decode(CategoryResponse.self, from: data)
        return categoryResponse.results
    }
}
