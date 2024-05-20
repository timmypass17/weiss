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
    @Environment(\.modelContext) private var modelContext // to save/update cards
    @State var cardDetailViewModel: CardDetailViewModel
    
    init(card: Card, group: Group, category: Category, userCard: UserCard?) {
        self._cardDetailViewModel = State(initialValue: CardDetailViewModel(card: card, group: group, category: category, userCard: userCard))
    }
    
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
                            Picker("Card Status", selection: $cardDetailViewModel.selectedStatus) {
                                ForEach(UserCard.CardStatus.allCases) { status in
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
                        didTapSaveButton()
                        dismiss()
                    }
                }
            }
        }
    }
    
    func didTapSaveButton() {
        switch cardDetailViewModel.selectedStatus {
        case .owned:
            print("Owned")
            if let userCard = cardDetailViewModel.userCard {
                print("Update card")
                // Update card
//                // TODO: Bug, updating array's values is not recomputing UserGroup.ownedCount (delete, then add does recompute)
//                userCard.cardStatus = .owned
//                userCard.quantity = cardDetailViewModel.quantity
                
                modelContext.delete(userCard)
                if let index = userCard.group?.userCards.firstIndex(where: { $0.cardID == cardDetailViewModel.card.id }) {
                    userCard.group?.userCards.remove(at: index)
                }
                addCard()
            } else {
                print("Add card")
                addCard()
            }
        case .unowned:
            print("Unowned")
            // Delete existing card
            if let userCard = cardDetailViewModel.userCard {
                print("Delete card")
                modelContext.delete(userCard)
                // IMPORTANT: Also have to remove card reference aswell to update UI
                if let index = userCard.group?.userCards.firstIndex(where: { $0.cardID == cardDetailViewModel.card.id }) {
                    userCard.group?.userCards.remove(at: index)
                }
            }
        case .wishlist:
            print("Wishlist")
            if let userCard = cardDetailViewModel.userCard {
                print("Update")
////                // Update card
//                userCard.cardStatus = .wishlist
//                userCard.quantity = 0
                
                modelContext.delete(userCard)
                if let index = userCard.group?.userCards.firstIndex(where: { $0.cardID == cardDetailViewModel.card.id }) {
                    userCard.group?.userCards.remove(at: index)
                }
                addCard()
            } else {
                print("Add card")
                addCard()
            }
        }
    }
    
    func addCard() {
        let userCategory: UserCategory
        let userGroup: UserGroup
        
        if let existingCategory = fetchUserCategory(categoryID: cardDetailViewModel.category.categoryID) {
            userCategory = existingCategory
        } else {
            let collectionToAdd = UserCategory(categoryID: cardDetailViewModel.category.categoryID, name: cardDetailViewModel.category.name)
            userCategory = collectionToAdd
            modelContext.insert(userCategory)
        }
        
        if let existingUserGroup = fetchUserGroup(groupID: cardDetailViewModel.card.groupID) {
            userGroup = existingUserGroup
        } else {
            let userGroupToAdd = UserGroup(
                groupID: cardDetailViewModel.group.id,
                name: cardDetailViewModel.group.name
            )
            userGroup = userGroupToAdd
            userGroup.userCategory = userCategory   // need to set both relationships
            userCategory.userGroups.append(userGroup)
            modelContext.insert(userGroup)
        }
        
        let cardToAdd = UserCard(
            cardID: cardDetailViewModel.card.id,
            imageUrl: cardDetailViewModel.card.imageUrl,
            cardStatus: cardDetailViewModel.selectedStatus,
            quantity: cardDetailViewModel.quantity,
            rarity: cardDetailViewModel.card.rarity,
            group: userGroup
        )
        
        
        userGroup.userCards.append(cardToAdd)
        modelContext.insert(cardToAdd)
        
    }
    
    func fetchUserGroup(groupID: Int) -> UserGroup? {
        do {
            let groupPredicate = #Predicate<UserGroup> {
                $0.groupID == groupID
            }
            var descriptor = FetchDescriptor(predicate: groupPredicate)
            descriptor.fetchLimit =  1
            let groups: [UserGroup] = try modelContext.fetch(descriptor)
            return groups.first
        } catch {
            print("Error fetching group \(groupID): \(error)")
            return nil
        }
    }
    
    // Weiss Schawarz (no id)
    func fetchUserCategory(categoryID: Int) -> UserCategory? {
        do {
            let groupPredicate = #Predicate<UserCategory> {
                $0.categoryID == categoryID
            }
            var descriptor = FetchDescriptor(predicate: groupPredicate)
            descriptor.fetchLimit =  1
            let collection: [UserCategory] = try modelContext.fetch(descriptor)
            return collection.first
        } catch {
            print("Error fetching collection \(categoryID): \(error)")
            return nil
        }
    }
}

//#Preview {
//    NavigationStack {
//        CardDetail(cardDetailViewModel: CardDetailViewModel(card: Card.samples[0]))
//            .environment(CardListViewModel(group: Group.sample[0], category: Category.samples[0]))
//    }
//}
