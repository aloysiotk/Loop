//
//  EditTaskView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/17/24.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(\.dismiss) private var dismiss
    @Bindable var task: Task
    
    @Query var groups: [Group]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                nameSection
                alertSection
                measurementsSection
            }
            .navigationDestination(for: Measurement.self, destination: { ms in EditMeasurementView(measurement: ms)})
            .toolbar { toolBarButton }
        }
        .onDisappear {onDisappear()}
        .interactiveDismissDisabled()
    }
    
    private var nameSection: some View {
        Section {
            TextField("Task Name", text: $task.name)
            Picker("Group", selection: $task.group) {
                ForEach(groups) { group in
                    Text(group.name).tag(Optional(group))
                }
            }
            LabeledTextEditor(label: "Task details", text: $task.details, height: 70)
        }
    }
    
    private var alertSection: some View {
        Section {
            DatePicker("Start At:", selection: $task.startingAt).fontWeight(.semibold)
            LabeledTextField("How many loops?", value: $task.loopCount, format: .number)
            LabeledTextField("Repeat every", value: $task.recurrence, format: .number)
            EnumPicker(label: "How many", selection: $task.recurrenceUnit)
            
        }
    }
    
    private var measurementsSection: some View {
        Section("Measurements") {
            ForEach(task.measurements) { measurement in
                NavigationLink(measurement.name, value: measurement)
            }
            Button("Add Measurement") {addMeasurementTouched()}
        }
    }
    
    private var toolBarButton: some View {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.bold)
    }
    
    private func onDisappear() {
        if task.hasChanges && task.startingAt > Date.now {
            notificationManager.scheduleNotification(id: task.id, title: task.name, body: task.details, startingAt: task.startingAt)
        }
    }
    
    private func addMeasurementTouched() {
        path.append(Measurement(task: task))
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:Loop.self, configurations: config)
        let context = container.mainContext
        
        return EditTaskView(task: Task(modelContext: context))
            .modelContainer(container)
            .environment(NotificationManager())
            .environment(NavigationPathHandler())
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
