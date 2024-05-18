//
//  DiscoverCell.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI

struct DiscoverCell: View {
    var group: Group
    
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
                Text("20 / 100")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                ProgressView(value: 0.2)
            }
        }
    }
}

#Preview {
    List {
        DiscoverCell(group: Group.sample[0])
    }
}
