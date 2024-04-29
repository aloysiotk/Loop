//
//  LoopData.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/18/24.
//

import Foundation
import SwiftData

@Model
final class LoopData: Codable, Identifiable{
    var id: UUID
    var loop: Loop?
    var measurement: Measurement?
    var value: String
    
    enum CodingKeys: CodingKey {
        case id
        case loop
        case measurement
        case value
    }
    
    init(value: String = "") {
        self.id = UUID()
        self.value = value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        value = try container.decode(String.self, forKey: .value)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
    }
}
