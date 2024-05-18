//
//  DiscoverDetailCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import SwiftUI

struct CardCell: View {
    let card: Card
    let width: CGFloat
    var isShowingPrice: Bool
    var isShowingRarity: Bool
    var isOwned: Bool
    
    var height: CGFloat {
        width * (280 / 200)
    }
    
    var body: some View {
        CardImage(imageUrl: card.imageUrl, width: width)
            .grayscale(isOwned ? 0 : 1)
            .overlay(alignment: .topTrailing) {
                VStack(alignment: .trailing, spacing: 2) {
                    if isShowingPrice {
                        Text(card.price?.marketPrice?.currencyString ?? "N/A")
                            .foregroundStyle(.white)
                            .padding(4)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.black)
                                    .opacity(0.7)
                            )
                    }
                    if isShowingRarity {
                        HStack(spacing: 2) {
                            Image(systemName: "sparkle")
                                .imageScale(.small)
                            Text(card.rarity.abbreviation)
                        }
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(4)

                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(card.rarity.color.opacity(1))
                        )
                    }
                }
                .padding(4)
            }
    }
}

#Preview {
    HStack {
        CardCell(card: Card.samples[0], width:  UIScreen.main.bounds.size.width * 0.3, isShowingPrice: true, isShowingRarity: true, isOwned: true)
        
        CardCell(card: Card.samples[0], width:  UIScreen.main.bounds.size.width * 0.3, isShowingPrice: false, isShowingRarity: false, isOwned: false)
    }
    
}