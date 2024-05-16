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
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    @StateObject var discoverViewModel = DiscoverViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem { Label("Collection", systemImage: "list.bullet") }
                
                NavigationStack {
                    DiscoverView()
                        .environmentObject(discoverViewModel)
                }
                .tabItem { Label("Discover", systemImage: "magnifyingglass") }
            }
        }
    }
}
