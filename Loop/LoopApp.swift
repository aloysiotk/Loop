//
//  LoopApp.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/16/24.
//

import SwiftUI
import SwiftData

@main
struct LoopApp: App {
    @State private var notificationManager = NotificationManager()
    @State private var alertHandler = AlertHandler()
    @State private var pathHandler = NavigationPathHandler()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Loop.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MockData.insertSampleDataIfNeeded(modelContext: sharedModelContainer.mainContext)
        
        return WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environment(notificationManager)
        .environment(alertHandler)
        .environment(pathHandler)
    }
    
    
}
