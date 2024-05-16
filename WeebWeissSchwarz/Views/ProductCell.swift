//
//  DiscoverDetailCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import SwiftUI

struct ProductCell: View {
    let product: Product
    let width: CGFloat
    var isShowingPrice: Bool
    var isOwned: Bool
    
    var height: CGFloat {
        width * (280 / 200)
    }
    
    var body: some View {
        ProductImage(imageUrl: product.imageUrl, width: width)
            .grayscale(isOwned ? 0 : 1)
            .overlay(alignment: .topTrailing) {
                if isShowingPrice {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(product.price?.marketPrice?.currencyString ?? "N/A")
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
                    .padding(4)
                }
            }
    }
}

#Preview {
    HStack {
        ProductCell(product: Product.samples[0], width:  UIScreen.main.bounds.size.width * 0.3, isShowingPrice: true, isOwned: true)
        
        ProductCell(product: Product.samples[0], width:  UIScreen.main.bounds.size.width * 0.3, isShowingPrice: false, isOwned: false)
    }
    
}
