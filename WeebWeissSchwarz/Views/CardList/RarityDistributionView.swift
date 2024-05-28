//
//  RarityDistribution.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/21/24.
//

import SwiftUI
import Charts

struct RarityDistributionChart: View {
    let rarityCount: [RarityCount]

    var body: some View {
        Chart(rarityCount) {
            BarMark(
                x: .value("Rarity", $0.rarity.abbreviation),
                y: .value("Count", $0.count)
            )
            .foregroundStyle($0.rarity.color)
        }
    }
}

//#Preview {
//    RarityDistributionView(cards: Card.samples)
//}
