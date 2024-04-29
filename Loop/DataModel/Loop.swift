//
//  Loop.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/16/24.
//

import Foundation
import SwiftData


@Model
final class Loop: Codable, Identifiable {
    var id: UUID
    var task: Task?
    var completionDate: Date
    @Relationship(deleteRule: .cascade, inverse: \LoopData.loop) var loopDatas: [LoopData]
    
    enum CodingKeys: CodingKey {
        case id
        case task
        case completionDate
        case loopDatas
    }
    
    init(task: Task, completionDate: Date = Date.now) {
        self.id = UUID()
        self.completionDate = completionDate
        self.loopDatas = []
        
        task.loops.append(self)
        
        for measurement in task.measurements {
            let loopData = LoopData()
            self.loopDatas.append(loopData)
            measurement.loopDatas.append(loopData)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        completionDate = try container.decode(Date.self, forKey: .completionDate)
        loopDatas = try container.decode([LoopData].self, forKey: .loopDatas)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(completionDate, forKey: .completionDate)
        try container.encode(loopDatas, forKey: .loopDatas)
    }
}

extension Loop {
    func delete() {
        loopDatas.forEach { loopData in
            loopData.measurement?.loopDatas.removeAll(where: {$0.id == loopData.id})
        }
        
        modelContext?.delete(self)
    }
}
