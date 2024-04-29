//
//  Measurement.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/18/24.
//

import Foundation
import SwiftData

@Model
final class Measurement: Identifiable, Codable {
    var id: UUID
    var task: Task?
    var name: String
    var type: MeasurementType
    @Relationship(deleteRule: .cascade, inverse: \LoopData.measurement) var loopDatas: [LoopData]
    
    enum CodingKeys: CodingKey {
        case id
        case task
        case desc
        case type
        case loopDatas
    }
    
    init(task: Task, name: String = "", type: MeasurementType = .number) {
        self.id = UUID()
        self.task = task
        self.name = name
        self.type = type
        self.loopDatas = []
        
        task.measurements.append(self)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .desc)
        type = try container.decode(MeasurementType.self, forKey: .type)
        loopDatas = try container.decode([LoopData].self, forKey: .loopDatas)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .desc)
        try container.encode(type, forKey: .type)
        try container.encode(loopDatas, forKey: .loopDatas)
    }
}

extension Measurement {
    var sortedLoopDatas: [LoopData] {
        loopDatas.sorted(by: {$0.loop?.completionDate ?? Date.distantPast < $1.loop?.completionDate ?? Date.distantPast})
    }
}
