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
    private var answers: [Int64: Int64] = [:]
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
    
    func updateAnswer(forQuestionIndex index: Int, value: Int64) {
        let question  = questions[index]
        guard let questionId = question.id else {
            return
        }
        answers[questionId] = value
    }
    
    func saveResults() -> Bool {
        guard let assessmentId = assessment.id else { return false}
        
        print("Answers count: \(answers.count)")
        print("Answers: \(answers)")
        
        if answers.isEmpty {
            print("No answers to save")
            return false
        }
        
        
        let totalScore = answers.values.reduce(0, +)
        
        let category = retrieveCategory(score: totalScore)
        
        let finalAnswers = answers.map {questionId, value in
            Answer(id: nil,
                   resultId: 0,
                   questionId: questionId,
                   value: value)
        }
        let result = Result(
            id: nil,
            assessmentId: assessmentId,
            score: totalScore,
            impairmentCategory: category,
            dateTaken: Date(),
            answers: finalAnswers
        )
        return databaseService.insertResult(result) != nil
    }
    
    private func retrieveCategory(score: Int64) -> String {
        if assessment.abbreviation == AssessmentAbbreviation.GAD7.rawValue {
            return GADCategories.categorizeFromScore(score).rawValue
            
        } else if (assessment.abbreviation == AssessmentAbbreviation.PHQ9.rawValue) {
            return PHQCategories.categorizeFromScore(score).rawValue
        } else {
            return "Unknown"
        }
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
