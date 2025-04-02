//
//  GAD7ImpairementCategory.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-02.
//

enum GAD7ImpairmentCategory: String {
    case none = "None"
    case minimal = "Minimal"
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
    
    static func categorizeFromScore(_ score: Int64) -> GAD7ImpairmentCategory {
        switch score {
        case 1...4:
            return .minimal
        case 5...9:
            return .mild
        case 10...14:
            return .moderate
        case 15...21:
            return .severe
        default:
            return .none
        }
    }
}
