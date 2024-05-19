//
//  ProductDetail.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/13/24.
//

import SwiftUI
import Charts
import SwiftData

struct CardDetail: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CardListViewModel.self) private var cardListViewModel: CardListViewModel
    @State var cardDetailViewModel: CardDetailViewModel
    @Environment(\.modelContext) private var modelContext // to save/update cards
    
    var body: some View {
        GeometryReader { geometry in
            List {
                CardImage(imageUrl: cardDetailViewModel.card.imageUrl, width: geometry.size.width * 0.9)
                    .listRowInsets(EdgeInsets()) // removes padding
                
                Section("My Collection") {
                    HStack{
                        Text("Status")
                        Spacer()
                        Menu(cardDetailViewModel.selectedStatus.rawValue.capitalized) {
                            Picker("Cad Status", selection: $cardDetailViewModel.selectedStatus) {
                                ForEach(CardStatus.allCases) { status in
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
                    Button("Save") {
                        saveCard()
                        dismiss()
                    }
                }
            }
        }
    }
    
    func saveCard() {
        let userCollection: UserCollection
        let userGroup: UserGroup
        
        if let existingCollection = fetchCollection(name: cardListViewModel.collectionName) {
            userCollection = existingCollection
        } else {
            let collectionToAdd = UserCollection(name: cardListViewModel.collectionName)
            userCollection = collectionToAdd
            modelContext.insert(userCollection)
        }
        
        if let existingUserGroup = fetchGroup(groupId: cardDetailViewModel.card.groupId) {
            userGroup = existingUserGroup
        } else {
            let userGroupToAdd = UserGroup(
                id: cardListViewModel.group.id,
                name: cardListViewModel.group.name
            )
            userGroup = userGroupToAdd
            modelContext.insert(userGroup)
            userGroup.collection = userCollection   // need to set both relationships
            userCollection.groups.append(userGroup)
        }
        
        let cardToAdd = UserCard(
            id: cardDetailViewModel.card.id,
            imageUrl: cardDetailViewModel.card.imageUrl,
            status: cardDetailViewModel.selectedStatus,
            quantity: cardDetailViewModel.quantity,
            rarity: cardDetailViewModel.card.rarity,
            group: userGroup
        )
        
        modelContext.insert(cardToAdd)
        userGroup.cards.append(cardToAdd)
    }
    
    func fetchGroup(groupId: Int) -> UserGroup? {
        do {
            let groupPredicate = #Predicate<UserGroup> {
                $0.id == groupId
            }
            let descriptor = FetchDescriptor(predicate: groupPredicate)
            let groups: [UserGroup] = try modelContext.fetch(descriptor)
            return groups.first
        } catch {
            print("Error fetching group \(groupId): \(error)")
            return nil
        }
    }
    
    // Weiss Schawarz (no id)
    func fetchCollection(name: String) -> UserCollection? {
        do {
            let groupPredicate = #Predicate<UserCollection> {
                $0.name == name
            }
            let descriptor = FetchDescriptor(predicate: groupPredicate)
            let collection: [UserCollection] = try modelContext.fetch(descriptor)
            return collection.first
        } catch {
            print("Error fetching collection \(name): \(error)")
            return nil
        }
    }
}

#Preview {
    NavigationStack {
        CardDetail(cardDetailViewModel: CardDetailViewModel(card: Card.samples[0]))
            .environment(CardListViewModel(group: Group.sample[0], collectionName: "Weiss"))
    }
}
