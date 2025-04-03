//
//  PHQCategories.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-03.
//

import Foundation

enum PHQCategories: String {
    case none = "None"
    case minimal = "Minimal"
    case mild = "Mild"
    case moderate = "Moderate"
    case moderatelySevere = "Moderately Severe"
    case severe = "Severe"
    
    static func categorizeFromScore(_ score: Int64) -> PHQCategories {
        switch score {
        case 1...4:
            return .minimal
        case 5...9:
            return .mild
        case 10...14:
            return .moderate
        case 15...19:
            return .moderatelySevere
        case 20...27:
            return .severe
        default:
            return .none
        }
    }
}
