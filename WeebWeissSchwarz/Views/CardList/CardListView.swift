//
//  DiscoverDetailView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import SwiftUI
import SwiftData

struct CardListView: View {
    @State var cardListViewModel: CardListViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var userGroup: UserGroup?

    // SwiftUI EnvironmentObject not available in View initializer. It is injected after object initialiazation.
    init(group: Group, category: Category, userGroup: UserGroup? = nil) {
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
                        } label: {
                            CardCell(
                                card: card,
                                width: geometry.size.width * 0.3,
                                isShowingPrice: cardListViewModel.isShowingPrice,
                                isShowingRarity: cardListViewModel.isShowingRarity,
                                isShowingMissing: cardListViewModel.isShowingMissing,
                                isOwned: userGroup?.cards.contains(where: { $0.id == card.id }) ?? false
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle(cardListViewModel.group.name)
            .searchable(text: $cardListViewModel.filteredText, prompt: "Filter by name")
            .padding([.horizontal, .bottom])
            .toolbar {
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
                    CardDetail(card: card)
                        .environment(cardListViewModel)
                }
            }
        }
    }
    
}
