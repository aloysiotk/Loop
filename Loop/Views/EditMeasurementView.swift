//
//  EditMeasurementView.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/25/24.
//

import SwiftUI
import SwiftData

struct EditMeasurementView: View {
    @Bindable var measurement: Measurement
    
    var body: some View {
        Form {
            Section {
                LabeledTextField("Name", value: $measurement.name)
                EnumPicker(label: "Type", selection: $measurement.type)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for:Loop.self, configurations: config)
        let context = container.mainContext
        
        let task = Task(modelContext: context)
        
        return EditMeasurementView(measurement:  Measurement(task: task))
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
