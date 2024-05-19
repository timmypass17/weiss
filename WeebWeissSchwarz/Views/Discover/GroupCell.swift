//
//  DiscoverCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI

struct GroupCell: View {
    var group: Group
    var userGroup: UserGroup?
    
    var ownedCount: Int {
        return userGroup?.cards.filter { $0.cardStatus == .owned }.count ?? 0
    }
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(group.name)
                    .lineLimit(1)
                
                Spacer()
                
                Text(group.abbreviation)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
            HStack {
                Text("\(ownedCount) / 100")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                ProgressView(value: Double(userGroup?.cards.count ?? 0) / 100)
            }
        }
    }
}

//#Preview {
//    List {
//        DiscoverCell(group: Group.sample[0])
//    }
//}
