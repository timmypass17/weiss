//
//  DiscoverDetailView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import SwiftUI
import SwiftData

struct CardList: View {
    @State var cardListViewModel: CardListViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var userGroup: UserGroup?   // don't put this in viewmodel cause it wont update from (@Query var userCollections: [UserCollection]) within viewmodel
    
    // SwiftUI EnvironmentObject not available in View initializer. It is injected after object initialiazation.
    init(group: Group, category: Category, userGroup: UserGroup?) {
        self._cardListViewModel = State(initialValue: CardListViewModel(group: group, category: category))
        self.userGroup = userGroup
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(cardListViewModel.cards) { card in
                        Button {
                            cardListViewModel.selectedCard = card
                            print("Selected Card: \(card.name)")
                        } label: {
                            CardCell(
                                card: card,
                                width: geometry.size.width * 0.3,
                                isShowingPrice: cardListViewModel.isShowingPrice,
                                isShowingRarity: cardListViewModel.isShowingRarity,
                                isShowingMissing: cardListViewModel.isShowingMissing,
                                isWishlist: userGroup?.userCards.contains { $0.cardID == card.id && $0.cardStatus == .wishlist } ?? false,
                                isOwned: userGroup?.userCards.contains { $0.cardID == card.id && $0.cardStatus == .owned } ?? false
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle(cardListViewModel.group.name)
            .searchable(text: $cardListViewModel.filteredText,  prompt: "Filter by name")
            .padding([.horizontal, .bottom])
            .toolbar {
                Button("Group Information", systemImage: "info.circle") {
                    cardListViewModel.isPresentingInfoSheet.toggle()
                }
                
                Menu("Options", systemImage: "ellipsis") {
                    Section("Sort By") {
                        Menu(cardListViewModel.selectedSort.rawValue.capitalized, systemImage: "line.3.horizontal.decrease") {
                            Picker("Select a sorting preference", selection: $cardListViewModel.selectedSort) {
                                ForEach(CardListViewModel.SortType.allCases) { sort in
                                    Text(sort.rawValue.capitalized)
                                }
                            }
                        }
                    }
                    
                    Section("Card Display") {
                        Toggle("Show Price", isOn: $cardListViewModel.isShowingPrice)
                        Toggle("Show Rarity", isOn: $cardListViewModel.isShowingRarity)
                        Toggle("Show Missing", isOn: $cardListViewModel.isShowingMissing)
                    }
                }
            }
            .sheet(item: $cardListViewModel.selectedCard) { card in
                NavigationStack {
                    CardDetail(
                        card: card,
                        group: cardListViewModel.group,
                        category: cardListViewModel.category,
                        userCard: userGroup?.userCards.first { $0.cardID == card.id }
                    )
                }
            }
            .sheet(isPresented: $cardListViewModel.isPresentingInfoSheet) {
                NavigationStack {
                    InformationView(cardListViewModel: cardListViewModel, userGroup: userGroup)
                    
                }
            }
        }
    }
    
}
//
//#Preview {
//    NavigationStack {
//        CardList(group: Group.samples[0], category: Category.samples[0], userGroup: nil)
//    }
//}
