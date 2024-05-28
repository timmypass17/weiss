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
    var isShowingMissing: Bool
    var isWishlist: Bool
    var isOwned: Bool
    
    var height: CGFloat {
        width * (280 / 200)
    }
    
    var body: some View {
        CardImage(imageUrl: card.imageUrl, width: width)
            .grayscale(isShowingMissing && !isOwned ? 1 : 0)
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
                        RarityTagView(rarity: card.rarity)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        (isShowingMissing && !isOwned ? .black.opacity(0.7) : card.rarity.color)
                                        //                                        .opacity(isShowingMissing && !isOwned ? 0.2 : 1)
                                    )
                            )
                    }
                }
                .padding(4)
            }
            .overlay(alignment: .topLeading) {
                if isWishlist {
                    Image(systemName: "bookmark.fill")
                        .foregroundStyle(.yellow)
                        .padding(4)
                }
            }
    }
}

#Preview {
    HStack {
        CardCell(card: Card.samples[0], width:  UIScreen.main.bounds.size.width * 0.3, isShowingPrice: true, isShowingRarity: true, isShowingMissing: true, isWishlist: false, isOwned: true)
        
        CardCell(card: Card.samples[0], width:  UIScreen.main.bounds.size.width * 0.3, isShowingPrice: true, isShowingRarity: true, isShowingMissing: true, isWishlist: true, isOwned: false)
    }
    
}
