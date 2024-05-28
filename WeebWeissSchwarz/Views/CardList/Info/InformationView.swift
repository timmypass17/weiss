//
//  InformationView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/22/24.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isRarityExpanded = false
    let cardListViewModel: CardListViewModel
    let userGroup: UserGroup?
    
    var rarityCount: [RarityCount] {
        var rarityFreq: [Card.Rarity: Int] = [:]
        for card in cardListViewModel.cards {
            rarityFreq[card.rarity, default: 0] += 1
        }
        return rarityFreq
            .map { RarityCount(rarity: $0.key, count: $0.value)}
            .sorted { $0.rarity < $1.rarity}
    }
    
    var mostExpensiveCards: [Card] {
        let sortedCards = cardListViewModel.cards
            .sorted { $0.price?.marketPrice ?? 0.0 > $1.price?.marketPrice ?? 0.0 }
        return Array(sortedCards.prefix(5))
    }
    
    var body: some View {
        List {
            Section("\(cardListViewModel.group.name) (\(cardListViewModel.group.abbreviation))") {
                RightDetailCell(
                    title: "Release Date",
                    desc: "\(cardListViewModel.group.publishedOn?.formatted(date: .abbreviated, time: .omitted) ?? "TBA")"
                )
                
                RightDetailCell(
                    title: "Card Amount",
                    desc: "\(cardListViewModel.cards.count)"
                )
                
                RightDetailCell(
                    title: "Net Worth",
                    desc: (cardListViewModel.cards.reduce(0) { $0 + ($1.price?.marketPrice ?? 0) }).currencyString
                )
                
            }
            
            Section("My Collection") {
                VStack {
                    HStack {
                        Text(cardListViewModel.group.name)
                            .lineLimit(1)
                        
                        Spacer()

                        Text("\((Double(userGroup?.ownedCount ?? 0) / Double(cardListViewModel.cards.count)).percentString)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("\(userGroup?.ownedCount ?? 0) / 100")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                        ProgressView(value: Float(userGroup?.ownedCount ?? 0) / 100)
                    }
                }

                HStack {
                    Text("Estimated Value")

                    Spacer()
                    
                    Text((userGroup?.getNetWorth(cards: cardListViewModel.cards) ?? 0).currencyString)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Rarity Distribution") {
                
                RarityDistributionChart(rarityCount: rarityCount)
                    .padding(.vertical)
                
                DisclosureGroup(
                    isExpanded: $isRarityExpanded,
                    content: {
                        ForEach(rarityCount.reversed()) { item in
                            HStack {
                                RarityTagView(rarity: item.rarity)
                                    .background(RoundedRectangle(cornerRadius: 5).fill(item.rarity.color))
                                Text(item.rarity.rawValue)
                                Text("(\(Int(Float(item.count) / Float(cardListViewModel.cards.count) * 100))%)")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(item.count)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    },
                    label: {
                        Text("Rarity List")
                    }
                )
            }
            
//            Section("Type Distribution") {
//                
//            }
//            
//            Section("Trait Distribution") {
//
//            }
            
            Section("Top 5 Most Expensive") {
                ForEach(mostExpensiveCards) { card in
                    HStack(alignment: .top) {
                        CardImage(imageUrl: card.imageUrl, width: 60)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(card.name)
                                .lineLimit(1)
                            
                            Text(card.price?.marketPrice?.currencyString ?? "N/A")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            
                            RarityTagView(rarity: card.rarity)
                                .background(RoundedRectangle(cornerRadius: 5).fill(card.rarity.color))
                        }
                    }
                }
            }
            
        }
        .navigationTitle(cardListViewModel.group.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        InformationView(cardListViewModel: CardListViewModel(group: Group.samples[0], category: Category.samples[0], userGroup: nil))
//    }
//}

extension Double {
    var percentString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0 // 0%
        formatter.maximumFractionDigits = 1 // 0.5%
        
        if let percentageString = formatter.string(from: NSNumber(value: self)) {
            return percentageString
        } else {
            return ""
        }
    }
    
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0 // 0
        formatter.maximumFractionDigits = 2 // 0.50
        
        if let currencyString = formatter.string(from: NSNumber(value: self)) {
            return currencyString
        } else {
            return ""
        }
    }
}
