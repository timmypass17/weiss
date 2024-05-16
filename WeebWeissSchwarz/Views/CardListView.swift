//
//  DiscoverDetailView.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/11/24.
//

import SwiftUI

struct CardListView: View {
    @StateObject var cardListViewModel: CardListViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    init(groupID: Int) {
        self._cardListViewModel = StateObject(wrappedValue: CardListViewModel(groupID: groupID))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(cardListViewModel.cards) { card in
                        Button {
                            cardListViewModel.selectedCard = card
                        } label: {
                            ProductCell(
                                product: card,
                                width: geometry.size.width * 0.3,
                                isShowingPrice: cardListViewModel.isShowingPrice,
                                isOwned: true
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
            }
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
                        Toggle("Price", isOn: $cardListViewModel.isShowingPrice)
                        Toggle("Owned", isOn: $cardListViewModel.isShowingOwned)
                    }
                }
            }
            .sheet(item: $cardListViewModel.selectedCard) { card in
                NavigationStack {
                    CardDetail(cardDetailViewModel: CardDetailViewModel(card: card))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CardListView(groupID: 23307)
            .navigationTitle("Chainsaw Man")
    }
}
