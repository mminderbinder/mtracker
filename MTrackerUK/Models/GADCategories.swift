//
//  GADCategories.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-03.
//

enum GADCategories: String, ScoreCategorizable {
    case none = "Not Specified"
    case noneMinimal = "None-Minimal"
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
    
    static let scoreMap: [ClosedRange<Int64>: GADCategories]  = [
        0...4: .noneMinimal,
        5...9: .mild,
        10...14: .moderate,
        15...21: .severe
    ]
    
    static func categorizeFromScore(_ score: Int64) -> GADCategories {
        for (range, category) in scoreMap {
            if range.contains(score) {
                return category
            }
        }
        return .none
    }
}
