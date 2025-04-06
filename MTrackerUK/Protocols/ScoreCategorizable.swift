//
//  ScoreCategorizable.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-05.
//

protocol ScoreCategorizable {
    associatedtype CategoryType: RawRepresentable where CategoryType.RawValue == String
    static var scoreMap: [ClosedRange<Int64>: CategoryType] {get}
}

extension ScoreCategorizable {
    static func getScoreRangeAsStrings() -> [String: String] {
        var stringScoreMap: [String: String] = [:]
        
        for(range, category) in Self.scoreMap {
            let rangeAsString = "\(range.lowerBound)-\(range.upperBound)"
            stringScoreMap[rangeAsString] = category.rawValue
        }
        return stringScoreMap
    }
}
