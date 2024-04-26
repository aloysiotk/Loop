//
//  ContentView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/16/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AlertHandler.self) private var alertHandler
    @Environment(NotificationManager.self) private var notificationManager
    @State private var selection: Group? = nil
    
    var body: some View {
        NavigationSplitView() {
            GroupGridView(selection: $selection)
        } detail: {
            TaskListView(group:$selection)
        }
        .task { await configureNotificationPermission() }
        .alertable()
    }
    
    private func configureNotificationPermission() async {
        if let action = await notificationManager.requestAuthorizationIfNeeded() {
            let alert = Alert(title: Text("Permissions"),
                              message: Text("Loop App need your permission in order to send notifications"),
                              primaryButton: .cancel(Text("Cancel")),
                              secondaryButton: .default(Text("Open Settings"), action: action))
            
            alertHandler.showAlert(alert)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(MockData.previewContainer)
        .environment(NotificationManager())
        .environment(AlertHandler())
        .environment(NavigationPathHandler())
}
