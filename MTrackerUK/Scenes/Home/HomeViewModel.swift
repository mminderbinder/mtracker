//
//  HomeViewModel.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-27.
//

import Foundation
class HomeViewModel {
    private var assessments: [Assessment] = []
    
    private let databaseService = DatabaseService.shared
    
    var onDataUpdated: (() -> Void)?
    
    func retrieveAssessments() {
        self.assessments = databaseService.retrieveAssessments()
        onDataUpdated?()
    }
    
    func numberOfRows() -> Int {
        return assessments.count
    }
    
    func assessment(at index: Int) -> Assessment {
        return assessments[index]
    }
}
