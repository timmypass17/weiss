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
            TabView {
                NavigationStack {
                    UserCategoryList()
                }
                .tabItem { Label("Collection", systemImage: "list.bullet") }
                
                NavigationStack {
                    CategoryList()
                }
                .tabItem { Label("Discover", systemImage: "magnifyingglass") }
            }
        }
        .modelContainer(for: UserCard.self) // infers UserGroup, UserCollection as well
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
