//
//  TaskListView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/17/24.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationPathHandler.self) private var pathHandler
    
    @Binding var group: Group?
    
    var body: some View {
        @Bindable var pathHandler = pathHandler
        
        if let group = group {
            NavigationStack(path: $pathHandler.path) {
                taskListView(group: group)
            }
        } else {
            groupUnavailable
        }
    }
    
    private var groupUnavailable: some View {
        ContentUnavailableView {
            Label("No group Selected", systemImage: "calendar.badge.exclamationmark")
        } description: {
            Text("Select a group!")
        }
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func taskListView(group: Group) -> some View {
        List {
            ForEach(group.tasks) { task in
                NavigationLink(task.name, value: task)
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar { toolbarButtons }
        .navigationDestination(for: Task.self, destination: { tsk in TaskView(task: tsk)})
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var toolbarButtons: some View {
        HStack {
            Button(action: addTaskTouched) {Label("Add Task", systemImage: "plus")}
            EditButton()
        }
    }
    
    private func addTaskTouched() {
        guard let group else { return }
        pathHandler.path.append(Task(group: group))
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            if let task = group?.tasks[index]  {
                modelContext.delete(task)
            }
        }
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:Loop.self, configurations: config)
        let context = container.mainContext
        
        @State var group = MockData.groups.first
        context.insert(group!)
        
        return TaskListView(group: $group)
            .modelContainer(for: Loop.self, inMemory: true)
            .modelContainer(container)
            .environment(NavigationPathHandler())
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
