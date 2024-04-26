//
//  Task.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/16/24.
//

import Foundation
import SwiftData

@Model
final class Task: Codable {
    var id: UUID
    var name: String
    var group: Group?
    var details: String
    var creationDate: Date
    var startingAt: Date
    var recurrence: Int
    var recurrenceUnit: RecurrenceUnit
    var loopCount: Int
    @Relationship(deleteRule: .cascade, inverse: \Loop.task) var loops: [Loop]
    var measurements: [Measurement]
    var tags: [Tag]
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case group
        case details
        case creationDate
        case startingAt
        case recurrence
        case recurrenceUnit
        case loopCount
        case loops
        case measurements
        case tags
    }
    
    init(name: String = "", group: Group, details: String = "", creationDate: Date = Date.now, startingAt: Date = Date.now, recurrence: Int = 0, recurrenceUnit: RecurrenceUnit = .day, loopCount: Int = 0, loops: [Loop] = [], measurements: [Measurement] = [], tags: [Tag] = []) {
        self.id = UUID()
        self.name = name
        self.group = group
        self.details = details
        self.creationDate = creationDate
        self.startingAt = startingAt
        self.recurrence = recurrence
        self.recurrenceUnit = recurrenceUnit
        self.loopCount = loopCount
        self.loops = loops
        self.measurements = measurements
        self.tags = tags
        
        group.tasks.append(self)
    }
    
    init(name: String = "", modelContext: ModelContext, details: String = "", creationDate: Date = Date.now, startingAt: Date = Date.now, recurrence: Int = 0, recurrenceUnit: RecurrenceUnit = .day, loopCount: Int = 0, loops: [Loop] = [], measurements: [Measurement] = [], tags: [Tag] = []) {
        self.id = UUID()
        self.name = name
        self.details = details
        self.creationDate = creationDate
        self.startingAt = startingAt
        self.recurrence = recurrence
        self.recurrenceUnit = recurrenceUnit
        self.loopCount = loopCount
        self.loops = loops
        self.measurements = measurements
        self.tags = tags
        
        modelContext.insert(self)
        
        var groups = [Group]()
        do {groups = try modelContext.fetch(FetchDescriptor<Group>( predicate: #Predicate<Group> { $0.name == "All" }))} catch {}
        
        self.group = groups.first
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decode(String.self, forKey: .details)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        startingAt = try container.decode(Date.self, forKey: .startingAt)
        recurrence = try container.decode(Int.self, forKey: .recurrence)
        recurrenceUnit = try container.decode(RecurrenceUnit.self, forKey: .recurrenceUnit)
        loopCount = try container.decode(Int.self, forKey: .loopCount)
        loops = try container.decode([Loop].self, forKey: .loops)
        measurements = try container.decode([Measurement].self, forKey: .measurements)
        tags = try container.decode([Tag].self, forKey: .tags)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(startingAt, forKey: .startingAt)
        try container.encode(recurrence, forKey: .recurrence)
        try container.encode(recurrenceUnit, forKey: .recurrenceUnit)
        try container.encode(loopCount, forKey: .loopCount)
        try container.encode(loops, forKey: .loops)
        try container.encode(measurements, forKey: .measurements)
        try container.encode(tags, forKey: .tags)
    }
}

extension Task {
    func getChartData() -> [(title: String, loopDatas: [LoopData])] {
        
        var data = [(title: String, loopDatas: [LoopData])]()
        
        for measurement in self.measurements {
            data.append((measurement.name, getLoopDatas(forMeasurement: measurement)))
        }
        
        return data
    }
    
    private func getLoopDatas(forMeasurement measurement: Measurement) -> [LoopData] {
        guard let modelContext else { return []}
        
        do {
            return try modelContext.fetch(FetchDescriptor<LoopData>( 
                predicate: #Predicate<LoopData> { $0.measurement.id == measurement.id },
                sortBy: [SortDescriptor(\.loop?.completionDate)]
            ))
        } catch {
            print("[getLoopDatas(forMeasurement:)] - Error fetching LoopDatas")
            return []
        }
    }
    
}
