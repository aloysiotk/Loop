//
//  Array.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/29/24.
//

import Foundation

extension Array where Element: LoopData {
    var sorted: [LoopData] {
        self.sorted(by: {$0.loop?.completionDate ?? Date.distantPast < $1.loop?.completionDate ?? Date.distantPast})
    }
}
