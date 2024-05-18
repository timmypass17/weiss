//
//  GroupAPIRequest.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation

struct GroupAPIRequest: APIRequest {
    var category: Category
    
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "https://tcgcsv.com/\(category.id)/groups")!)
    }
    
    func decodeResponse(data: Data) throws -> [Group] {
        let decoder = JSONDecoder()
        let groupResponse = try decoder.decode(GroupResponse.self, from: data)
        return groupResponse.results
    }
}
