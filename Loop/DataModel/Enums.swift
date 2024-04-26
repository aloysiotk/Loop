//
//  Enums.swift
//  Loop
//
//  Created by Aloysio Tiscoski on 4/16/24.
//

import Foundation

enum RecurrenceUnit: String, Codable, CaseIterable {
    case second
    case minute
    case hour
    case day
    case week
    case month
    case year
}

enum MeasurementType: String, Codable, CaseIterable {
    case text
    case number
}

enum MeasurementAggregation: String, Codable, CaseIterable {
    case sum
    case average
    case minimum
    case maximum
}
