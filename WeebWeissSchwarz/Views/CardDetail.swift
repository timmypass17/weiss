//
//  ProductDetail.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/13/24.
//

import SwiftUI
import Charts

struct CardDetail: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var cardDetailViewModel: CardDetailViewModel

    var body: some View {
        GeometryReader { geometry in
            List {
                ProductImage(imageUrl: cardDetailViewModel.card.imageUrl, width: geometry.size.width * 0.9)
                    .listRowInsets(EdgeInsets()) // removes padding
                
                Section("My Collection") {
                    HStack{
                        Text("Status")
                        Spacer()
                        Menu(cardDetailViewModel.selectedStatus.rawValue.capitalized) {
                            Picker("Cad Status", selection: $cardDetailViewModel.selectedStatus) {
                                ForEach(CardDetailViewModel.Status.allCases) { status in
                                    Text(status.rawValue.capitalized)
                                }
                            }
                        }
                    }
                    
                    if case .owned = cardDetailViewModel.selectedStatus {
                        Stepper(value: $cardDetailViewModel.quantity, in: 0...Int.max) {
                            HStack {
                                Text("Quantity")
                                Text("\(cardDetailViewModel.quantity)x")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
                
                Section("Card Info", isExpanded: $cardDetailViewModel.isExpandedInfo) {
                    RightDetailCell(title: "Name", desc: cardDetailViewModel.card.name)
                    
                    ForEach(cardDetailViewModel.card.extendedData) { data in
                        if data.name != "CardText" {
                            RightDetailCell(title: data.displayName, desc: data.value)
                        }
                    }

                    DisclosureGroup("Card Text", isExpanded: $cardDetailViewModel.isExpandedCardText) {
                        Text(cardDetailViewModel.card.cardText)
                    }
                }
                
                if let price = cardDetailViewModel.card.price {
                    Section("Prices") {
                        DisclosureGroup(
                            isExpanded: $cardDetailViewModel.isExpandedAdditionalPrices,
                            content: {
                                ForEach(price.data) {
                                    RightDetailCell(title: $0.name, desc: $0.price.currencyString)
                                }
                            },
                            label: {
                                HStack {
                                    Image("tcgLogo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 22)
                                    Text("Market Price")
                                    
                                    Spacer()
                                    
                                    Text(price.marketPrice?.currencyString ?? "-")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        )
                        
                        Chart(price.data) {
                            BarMark(
                                x: .value("Price Range", $0.name),
                                y: .value("Price", $0.price)
                            )
                            
                            if let marketPrice = price.marketPrice {
                                RuleMark(y: .value("MarketPrice", marketPrice))
                                    .foregroundStyle(.green)
                                    .annotation(position: .automatic,
                                                alignment: .bottomLeading) {
                                        Text("Market Price: \(marketPrice.currencyString)")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                            }
                        }
                        .padding(.vertical, 8)

                    }
                    
                }
            }
            .navigationTitle(cardDetailViewModel.card.name)
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(SidebarListStyle())
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
}

#Preview {
    NavigationStack {
        CardDetail(cardDetailViewModel: CardDetailViewModel(card: Product.samples[0]))
    }
}
