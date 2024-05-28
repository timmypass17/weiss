//
//  RarityTagView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/22/24.
//

import SwiftUI

struct RarityTagView: View {
    let rarity: Card.Rarity
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "sparkle")
                .imageScale(.small)
            Text(rarity.abbreviation)
        }
        .font(.caption2)
        .foregroundStyle(.white)
        .padding(4)
//        .background(
//            RoundedRectangle(cornerRadius: 5)
//                .fill(
//                    (isShowingMissing && !isOwned ? .black.opacity(0.7) : card.rarity.color)
//                )
//        )
    }
}

//#Preview {
//    RarityTagView()
//}
