//
//  PHQCategories.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-03.
//

import Foundation

enum PHQCategories: String {
    case none = "Not Specified"
    case noneMinimal = "None-Minimal"
    case mild = "Mild"
    case moderate = "Moderate"
    case moderatelySevere = "Moderately Severe"
    case severe = "Severe"
    
    static let scoreMap: [ClosedRange<Int64>: PHQCategories] = [
        0...4: .noneMinimal,
        5...9: .mild,
        10...14: .moderate,
        15...19: .moderatelySevere,
        20...27: .severe
    ]
    
    static func categorizeFromScore(_ score: Int64) -> PHQCategories {
        for(range, category) in scoreMap {
            if range.contains(score) {
                return category
            }
        }
        return .none
    }
}
