//
//  ProductImage.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/13/24.
//

import SwiftUI

struct ProductImage: View {
    let imageUrl: String
    let width: CGFloat
    
    var height: CGFloat {
        width * (280 / 200)
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color(uiColor: UIColor.tertiarySystemFill)
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

//#Preview {
//    ProductImage()
//}
