//
//  TaskView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/24/24.
//

import SwiftUI
import SwiftData
import Charts

struct TaskView: View {
    @Environment(NavigationPathHandler.self) private var pathHandler
    
    @Bindable var task: Task
    
    @State var isEditingTask = false
    
    var body: some View {
        Form {
            loopDataSection
            addLoopSection
            Text(task.details)
            loopHistorySection
        }
        .navigationTitle(task.name)
        .toolbar { editTaskButton }
        .onAppear { viewDidAppear() }
        .sheet(isPresented: $isEditingTask){EditTaskView(task: task)}
        .navigationDestination(for: Loop.self, destination: { lp in EditLoopView(loop: lp)})
    }
    
    private var addLoopSection: some View {
        Section {
            Button("Add Loop") {
                pathHandler.path.append(Loop(task: task))
            }
        }
    }
    
    private var loopDataSection: some View {
        Section("Loops Data") {
            Chart(task.getChartData(), id: \.title) { data in
                ForEach(data.loopDatas) { loopData in
                    if let loop = loopData.loop {
                        LineMark(x: .value("date", loop.completionDate), y: .value("value", Double(loopData.value) ?? 4))
                    }
                }
            }
            //.chartXAxis(.hidden)
            .frame(height: 200)
        }
    }
    
    private var loopHistorySection: some View {
        Section("Loops History") {
            List(task.loops) { loop in
                Text(loop.completionDate.formatted(date: .long, time: .shortened))
            }
        }
    }
    
    private var editTaskButton: some View {
        Button("Edit") {
            isEditingTask = true
        }
    }
    
    private func viewDidAppear() {
        if task.name == "" {
            isEditingTask = true
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:Loop.self, configurations: config)
        let context = container.mainContext
        
        return TaskView(task: Task(name: "Test Task", modelContext: context))
            .modelContainer(container)
            .environment(NavigationPathHandler())
            .environment(NotificationManager())
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
