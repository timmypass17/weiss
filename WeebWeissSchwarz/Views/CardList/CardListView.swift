//
//  DiscoverDetailView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import SwiftUI

struct CardListView: View {
    @State var cardListViewModel: CardListViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    init(group: Group, collectionName: String) {
        self._cardListViewModel = State(wrappedValue: CardListViewModel(group: group, collectionName: collectionName))
    }
    
    init(userGroup: UserGroup) {
        let group = Group(id: userGroup.id, name: userGroup.name, abbreviation: "ABBR", publishedOn: .now)
        self._cardListViewModel = State(wrappedValue: CardListViewModel(group: group, collectionName: userGroup.collection!.name))
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
                                isShowingPrice: cardListViewModel.isShowingPrice, isShowingRarity: cardListViewModel.isShowingRarity,
                                isOwned: true
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
                        Toggle("Show Owned", isOn: $cardListViewModel.isShowingOwned)
                    }
                }
            }
            .sheet(item: $cardListViewModel.selectedCard) { card in
                NavigationStack {
                    CardDetail(cardDetailViewModel: CardDetailViewModel(card: card))
                        .environment(cardListViewModel)
                }
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        CardListView(group: Group(id: 23307, name: "Chainsaw Man", abbreviation: "CSM", publishedOn: .now), collectionName: "Weiss Schwarz")
//    }
//}
