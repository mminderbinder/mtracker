//
//  HomeViewModel.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-27.
//

import Foundation
class HomeViewModel {
    private(set) var assessments: [Assessment] = []
    private let databaseService = DatabaseService.shared
    
    var onDataUpdated: (() -> Void)?
    
    func retrieveAssessments() {
        self.assessments = databaseService.retrieveAssessments()
        print("Fetched \(assessments.count) assessments from the database")
        onDataUpdated?()
    }
    
    func numberOfRows() -> Int {
        return assessments.count
    }
    
    func assessment(at index: Int) -> Assessment {
        return assessments[index]
    }
}
