//
//  ResultsViewModel.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-06.
//

import Foundation

class ResultsViewModel {
        
    private var results: [Result] = []
    
    private let databaseService = DatabaseService.shared
    
    var onDataUpdated: (() -> Void)?
    
    func retrieveResults() {
        self.results = databaseService.retrieveResults()
        print("ResultsViewModel: Retrieved \(results.count) results from database")
        onDataUpdated?()
    }
    
    func retrieveAssessmentName(_ assessmentId: Int64) -> String {
        switch assessmentId {
        case 1: return "GAD-7"
        case 2: return "PHQ-9"
        default: return "N/A"
        }
    }
    
    func retrieveDate(_ dateTaken: Date?) -> String {
        var dateString = ""
        
        if let date = dateTaken {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateString = formatter.string(from: date)
        } else {
            dateString = "N/A"
        }
        return dateString
    }
    
    func numberOfRows() -> Int {
        return results.count
    }
    
    func result(at index: Int) -> Result {
        return results[index]
    }
}
