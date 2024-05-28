//
//  WeebWeissSchwarzApp.swift
//  WeebWeissSchwarz
//
//  Created by Timmy Nguyen on 5/10/24.
//

import SwiftUI
import SwiftData

@main
struct WeebWeissSchwarzApp: App {
    
    var body: some Scene {
        WindowGroup {
            WeissTab()
        }
        .modelContainer(for: UserCollection.self) // infers UserGroup, UserCollection...
    }
}

struct WeissTab: View {
    @Query var userCollections: [UserCollection]
    @Environment(\.modelContext) private var modelContext

    var userCollection: UserCollection? {
        return userCollections.first
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                UserCategoryList(userCategories: userCollection?.userCategories ?? [], removeUserCategory: removeUserCategory(_:))
            }
            .tabItem { Label("Collection", systemImage: "list.bullet") }
            
            NavigationStack {
                CategoryList(userCategories: userCollection?.userCategories ?? [])
            }
            .tabItem { Label("Discover", systemImage: "magnifyingglass") }
        }
    }
    
    func removeUserCategory(_ userCategory: UserCategory) {
        guard let index = userCollection?.userCategories.firstIndex(where: { $0.categoryID == userCategory.categoryID })
        else { return }
        
        userCollection?.userCategories.remove(at: index)
        modelContext.delete(userCategory)
    }
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: UserCategory.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<UserCategory>()).isEmpty {
            UserCategory.samples.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
