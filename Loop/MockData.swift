//
//  MockData.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/18/24.
//

import Foundation
import SwiftData

@MainActor
struct MockData {
    static let groups = [Group(name: "Today", icon: "calendar", tasks: [], color: "mBlue"),
                  Group(name: "Pending", icon: "calendar", tasks: [], color: "mRed"),
                  Group(name: "All", icon: "tray.fill", tasks: [], color: "mBlack"),
                  Group(name: "Completed", icon: "checkmark", tasks: [], color: "mGray")]
    
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Loop.self, configurations: config)
            
            insertSampleDataIfNeeded(modelContext: container.mainContext)
            
            return container
        } catch {
            print("MockData/previewContainer - Failed to create model container for previewing: \(error.localizedDescription)")
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    static func insertSampleDataIfNeeded(modelContext: ModelContext) {
        var groups = [Group]()
        do {groups = try modelContext.fetch(FetchDescriptor<Group>())} catch {}
        
        if groups.count == 0 {
            for group in MockData.groups {
                modelContext.insert(group)
            }
        }
    }
}
