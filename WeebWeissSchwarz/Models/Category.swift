//
//  Category.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/18/24.
//

import Foundation

struct CategoryResponse: Decodable {
    var totalItems: Int
    var results: [Category]
}

struct Category: Decodable {
    var categoryId: Int
    var name: String
    var modifiedOn: String
    var categoryDescription: String?
    var popularity: Int
}

extension Category: Identifiable {
    var id: Int { categoryId }
}

extension Category: Hashable {}

extension Category {
    static let samples: [Category] = [
        Category(categoryId: 20, name: "Weiss Schwarz", modifiedOn: "2024-05-17T18:46:47.25", categoryDescription: "Take the stage and relive climactic moments with your favorite characters from anime, manga, and video games! Buy Weiss Schwarz cards and singles, booster boxes, and more.", popularity: 34495),
        Category(categoryId: 68, name: "One Piece Card Game", modifiedOn: "2024-05-17T13:40:18.863", categoryDescription: "Choose your Leader, build your crew of Characters, and set sail for adventure! Shop thousands of sellers for the best prices on One Piece cards, starter decks, booster boxes, and more.", popularity: 0)
    ]
}
