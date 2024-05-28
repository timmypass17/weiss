//
//  TagView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/16/24.
//

import SwiftUI

struct TagView: View {
    var text: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "sparkle")
            Text(text)
        }
        .font(.caption)
        .foregroundStyle(color)
        .padding(.vertical, 4)
        .padding(.horizontal, 7)
    }
}

struct RarityCountTagView: View {
    var amount: Int
    var rarity: Card.Rarity
    
    var body: some View {
        TagView(text: "\(amount) \(rarity.abbreviation)", color: rarity.color)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(rarity.color.opacity(0.15))
            )
    }
}

#Preview {
    ForEach(Card.Rarity.allCases, id: \.self) { rarity in
        TagView(text: rarity.rawValue, color: rarity.color)
    }
}

#Preview {
    ForEach(Card.Rarity.allCases, id: \.self) { rarity in
        RarityCountTagView(amount: 10, rarity: rarity)
    }
}
