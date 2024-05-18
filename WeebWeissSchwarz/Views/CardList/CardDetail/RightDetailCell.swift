//
//  RightDetailCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/13/24.
//

import SwiftUI

struct RightDetailCell: View {
    let title: String
    let desc: String
    
    @State var isExpanded = false
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(desc)
                .foregroundStyle(.secondary)
                .lineLimit(isExpanded ? nil : 1)
        }
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}

//#Preview {
//    RightDetailCell()
//}
