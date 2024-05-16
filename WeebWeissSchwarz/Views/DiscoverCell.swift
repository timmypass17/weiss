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
        HStack {
            Text(group.name)
                .lineLimit(1)
            
            Spacer()
            
            Text(group.abbreviation)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    DiscoverCell(group: GroupResponse.sample.results[0])
}
