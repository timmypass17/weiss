//
//  Group.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import Foundation

struct GroupResponse: Decodable {
    let totalItems: Int
    let results: [Group]
}

struct Group: Identifiable {
    var id: Int
    var name: String
    var abbreviation: String
    var publishedOn: Date
}

extension Group: Hashable {}

extension Group: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "groupId"
        case name
        case abbreviation
        case publishedOn
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.abbreviation = try container.decode(String.self, forKey: .abbreviation)
        let publishedDateString = try container.decode(String.self, forKey: .publishedOn)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: publishedDateString) {
            self.publishedOn = date
        } else {
            self.publishedOn = .distantFuture
        }
        
    }
}


extension Group {
    static let sample: [Group] = [
        Group(id: 23307, name: "Chainsaw Man", abbreviation: "CSM", publishedOn: .now),
        Group(id: 23508, name: "JoJo's Bizarre Adventure: Stardust Crusaders Premium Booster", abbreviation: "JJ", publishedOn: .now),
        Group(id: 23507, name: "[OSHI NO KO]", abbreviation: "OSK", publishedOn: .now)
    ]
}

//let dateString = "2024-10-04T00:00:00"
//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//
//if let date = dateFormatter.date(from: dateString) {
//    self.publishedOn = publishedOnString
//} else {
//    self.publishedOn = .distantFuture
//}

