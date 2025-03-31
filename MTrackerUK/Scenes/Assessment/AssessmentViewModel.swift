//
//  AssessmentViewModel.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-28.
//

import Foundation
class AssessmentViewModel {

    private let assessment: Assessment
    private var questions: [Question] = []
    private let databaseService = DatabaseService.shared
    
    init(assessment: Assessment) {
        self.assessment = assessment
    }
    
    var onDataUpdated: (() -> Void)?
    
    func retrieveQuestions() {
        guard let assessmentId = assessment.id else {
            print("Error: no Assessment ID!")
            return
        }
        
        self.questions = databaseService.retrieveAssessmentQuestions(forAssessmentId: assessmentId)
        onDataUpdated?()
    }
    
    func numberOfRows() -> Int {
        return questions.count
    }
    
    func question(at index: Int) -> Question {
        return questions[index]
    }
    
    var assessmentTitle: String {
        return assessment.abbreviation
    }
    var assessmentInstructions: String {
       return assessment.instructions
    }
}
