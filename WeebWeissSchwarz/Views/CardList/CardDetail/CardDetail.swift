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
    @Environment(CardListViewModel.self) private var cardListViewModel
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
        // Existing card
        if let userCard = cardDetailViewModel.userCard {
            if cardDetailViewModel.selectedStatus == .unowned {
                removeCard(userCard: userCard)
            } else {
                updateCard(userCard: userCard)
            }
        } else {
            // New card
            addCard()
        }

    }
    
    // Note: Why are we removing and inserting for an update? Because UserGroup.ownedCount is a computed property which contains [UserCard]. Updating a userCard property within the array (i.e. userCard.cardStatus = .wishlist) does not recompute value. Only inserting and deleting an array will recompute UserGroup.ownedCount. This fixes bug where user sets card status to wishlist but the ownedCount is unchanged.
    func updateCard(userCard: UserCard) {
        removeCard(userCard: userCard)
        addCard()
    }
    
    func removeCard(userCard: UserCard) {
        guard let userGroup = userCard.group,
              let userCategory = userGroup.userCategory,
              let userCollection = userCategory.userCollection
        else { return }
        
        if let userCardIndex = userGroup.userCards.firstIndex(where: { $0.cardID == userCard.cardID }) {
            print("Remove card: \(userCard.cardStatus)")
            userGroup.userCards.remove(at: userCardIndex) // note: also remove's userCard's reference to userGroup (userCard.group = nil)
            modelContext.delete(userCard)
        }
    }
    
    func addCard() {
        let userCategory: UserCategory
        let userGroup: UserGroup
        
        let userCollection = fetchUserCollection()
        
        if let existingCategory = userCollection.userCategories.first(where: { $0.categoryID == cardDetailViewModel.category.categoryID }) {
            print("Fetched category")
            userCategory = existingCategory
        } else {
            print("Create category: \(cardDetailViewModel.category.categoryID)")
            let userCategoryToAdd = UserCategory(categoryID: cardDetailViewModel.category.categoryID, name: cardDetailViewModel.category.name)
            userCategory = userCategoryToAdd
            userCategory.userCollection = userCollection
            userCollection.userCategories.append(userCategoryToAdd)
            modelContext.insert(userCategory)
        }
        
        if let existingUserGroup = userCategory.userGroups.first(where: { $0.groupID == cardDetailViewModel.group.groupID }) {
            print("Found group: \(existingUserGroup.userCategory?.categoryID)")
            userGroup = existingUserGroup
        } else {
            print("Create group: \(cardDetailViewModel.group.id)")
            let userGroupToAdd = UserGroup(groupID: cardDetailViewModel.group.id, name: cardDetailViewModel.group.name, abbreviation: cardDetailViewModel.group.abbreviation)
            userGroup = userGroupToAdd
            userGroup.userCategory = userCategory     // need to set both relationships
            userCategory.userGroups.append(userGroup) // this to update UI
            modelContext.insert(userGroup)
            cardListViewModel.userGroup = userGroup // set userGroup in vm
        }
        
        print("Add Card")
        let cardToAdd = UserCard(
            cardID: cardDetailViewModel.card.id,
            imageUrl: cardDetailViewModel.card.imageUrl,
            cardStatus: cardDetailViewModel.selectedStatus,
            quantity: cardDetailViewModel.quantity,
            rarity: cardDetailViewModel.card.rarity
        )
        
        userGroup.userCards.append(cardToAdd)
        cardToAdd.group = userGroup
        modelContext.insert(cardToAdd)
    }

    func fetchUserCollection() -> UserCollection {
        do {
            var descriptor = FetchDescriptor<UserCollection>()
            descriptor.fetchLimit =  1
            let collections: [UserCollection] = try modelContext.fetch(descriptor)
            if let collection = collections.first {
                return collection
            } else {
                let userCollection = UserCollection()
                modelContext.insert(userCollection)
                return userCollection
            }
        } catch {
            print("Error fetching user collection: \(error)")
            let userCollection = UserCollection()
            modelContext.insert(userCollection)
            return userCollection
        }
    }
}

//#Preview {
//    NavigationStack {
//        CardDetail(cardDetailViewModel: CardDetailViewModel(card: Card.samples[0]))
//            .environment(CardListViewModel(group: Group.sample[0], category: Category.samples[0]))
//    }
//}
