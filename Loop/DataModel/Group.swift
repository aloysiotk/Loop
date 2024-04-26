//
//  Group.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/18/24.
//

import Foundation
import SwiftData

@Model
final class Group: Codable {
    var id: UUID
    var name: String
    var icon: String
    @Relationship(deleteRule: .cascade, inverse: \Task.group) var tasks: [Task]
    var color: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case icon
        case tasks
        case color
    }
    
    init(name: String, icon: String, tasks: [Task], color: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.tasks = tasks
        self.color = color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        icon = try container.decode(String.self, forKey: .icon)
        tasks = try container.decode([Task].self, forKey: .tasks)
        color =  try container.decode(String.self, forKey: .color)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(color, forKey: .color)
    }
}
