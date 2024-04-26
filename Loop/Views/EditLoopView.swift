//
//  EditLoopView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/25/24.
//

import SwiftUI
import SwiftData

struct EditLoopView: View {
    @Bindable var loop: Loop
    
    var body: some View {
        Form {
            DatePicker("Completion Date", selection: $loop.completionDate, displayedComponents: .date).fontWeight(.semibold)
            loopDataSection
        }
        .navigationTitle("Loop Data")
    }
    
    private var loopDataSection: some View {
        Section("Loop Data") {
            List($loop.loopDatas) { $loopData in
                let keyboardType: UIKeyboardType? = loopData.measurement.type == .number ? .decimalPad : nil
                LabeledTextField("\(loopData.measurement.name)", value: $loopData.value, keyboardType: keyboardType)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:Loop.self, configurations: config)
        let context = container.mainContext
        
        let task = Task(name: "Test Task", modelContext: context)
        task.measurements.append(Measurement(task: task, name: "1", type: .number))
        task.measurements.append(Measurement(task: task, name: "2", type: .number))
        task.measurements.append(Measurement(task: task, name: "3", type: .text))
        
        return EditLoopView(loop: Loop(task: task))
            .modelContainer(container)
            .environment(NavigationPathHandler())
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
