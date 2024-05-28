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
    var systemName: String? = nil
    
    @State var isExpanded = false
    
    var body: some View {
        HStack {
            if let systemName {
                Image(systemName: systemName)
                    .roundedBackground(color: .accent)
                    .padding(.trailing, 8)
            }
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

#Preview {
    RightDetailCell(title: "Title", desc: "Description", systemName: "person")
        .padding()
}


extension Image {
    func roundedBackground(color: Color) -> some View {
        self
            .font(.system(size: 14))
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .frame(width: 28, height: 28)
                    .foregroundStyle(color)
            )
    }
}

//struct ColorfulIconLabelStyle: LabelStyle {
//    var color: Color
//    
//    func makeBody(configuration: Configuration) -> some View {
//        Label {
//            configuration.title
//        } icon: {
//            configuration.icon
//                .font(.system(size: 14))
//                .foregroundColor(.white)
//                .background(RoundedRectangle(cornerRadius: 7).frame(width: 28, height: 28).foregroundColor(color))
//        }
//    }
//}
