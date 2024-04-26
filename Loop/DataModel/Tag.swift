//
//  Tag.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/18/24.
//

import Foundation
import SwiftData

@Model
final class Tag: Codable {
    var name: String
    var tasks: [Task]
    
    enum CodingKeys: CodingKey {
        case name
        case tasks
    }
    
    init(name: String, tasks: [Task]) {
        self.name = name
        self.tasks = tasks
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        tasks = try container.decode([Task].self, forKey: .tasks)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(tasks, forKey: .tasks)
    }
}
