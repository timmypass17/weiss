//
//  HomeCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/16/24.
//

import SwiftUI

struct GroupCell: View {
    var group: UserGroup
    
//    var rarityCount: [RarityCount] {
//        let rarityFreq = group.cards.reduce(into: [Card.Rarity : Int]()) { partialResult, userCard in
//            partialResult[userCard.rarity, default: 0] += 1
//        }
//        return rarityFreq.map { RarityCount(rarity: $0.key, count: $0.value) }
//    }
    

    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(group.name)
                    .lineLimit(1)
                
                Spacer()
                
                Text("$50")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
            HStack {
                Text("\(group.cards.count) / 100")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                ProgressView(value: Float(group.cards.count) / 100)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(group.rarityCount) {
                        RarityTagView(amount: $0.count, rarity: $0.rarity)
                    }
                }
            }
            .padding(.top, 4)
        }
    }
}

//#Preview {
//    GroupCell(group: UserGroup.samples[0])
//}