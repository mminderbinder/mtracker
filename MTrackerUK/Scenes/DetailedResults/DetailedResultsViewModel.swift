//
//  DetailedResultsViewModel.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-04.
//

import Foundation

class DetailedResultsViewModel {
    
    private var result: Result?
    private let resultId: Int64
    private var assessmentName: String?
    private var scoreRangesMap: [String: String] = [:]
    private let databaseService = DatabaseService.shared
    
    init(resultId: Int64) {
        self.resultId = resultId
        print("Result ID: \(resultId)")
    }
    
    var onDataUpdated: (() -> Void)?
    
    func loadData() {
        
        self.result = databaseService.retrieveSingleResult(byId: self.resultId)
        
        if let result = result {
            let assessmentId = result.assessmentId
            print ("Assessment ID: \(assessmentId)")
            retrieveScoreMapAndAssessmentName(byId: assessmentId)
            onDataUpdated?()
        }
    }
    
    func retrieveScoreMapAndAssessmentName(byId id: Int64) {
        
        switch id {
        case 1:
            scoreRangesMap = GADCategories.getScoreRangeAsStrings()
            assessmentName = AssessmentAbbreviation.GAD7.rawValue
        case 2:
            scoreRangesMap = PHQCategories.getScoreRangeAsStrings()
            assessmentName = AssessmentAbbreviation.PHQ9.rawValue
        default: scoreRangesMap = [:]
            }
    }
    
    func getScoreRangeAt(index: Int) -> (range: String, category: String)? {
        let sortedKeys = scoreRangesMap.keys.sorted() {
            
            let range1 = $0.split(separator: "-").first!
            let range2 = $1.split(separator: "-").first!
            
            return Int(range1)! < Int(range2)!
        }
        
        guard index < sortedKeys.count else { return nil }
        
        let key = sortedKeys[index]
        guard let value = scoreRangesMap[key] else { return nil }
        
        return (range: key, category: value)
    }
    
    func deleteResult() -> Bool {
        return databaseService.deleteResult(byId: resultId)
    }
    
    func getAssessmentName() -> String? {
        return assessmentName
    }
    
    func numberOfRows() -> Int {
        return scoreRangesMap.count
    }
    
    func getDateTaken() -> Date? {
        return result?.dateTaken
    }
    
    func getScore() -> String? {
        guard let score = result?.score else { return nil }
        return String(score)
    }
    
    func getImpairmentLevel() -> String? {
        return result?.impairmentCategory
    }
}
