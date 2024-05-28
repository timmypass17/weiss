//
//  HomeCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/16/24.
//

import SwiftUI

struct UserGroupCell: View {
    var userGroup: UserGroup
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(userGroup.name)
                    .lineLimit(1)
                
                Spacer()
                
                Text("$50")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
            HStack {
                Text("\(userGroup.ownedCount) / 100")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                ProgressView(value: Float(userGroup.ownedCount) / 100)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(userGroup.rarityCount
                        .map { RarityCount(rarity: $0.key, count: $0.value) }
                        .sorted(by: { $0.rarity < $1.rarity } )) {
                        RarityCountTagView(amount: $0.count, rarity: $0.rarity)
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
