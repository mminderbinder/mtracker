//
//  DatabaseService.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-25.
//

import Foundation
import SQLite

class DatabaseService {
    
    static let shared = DatabaseService()
    private var db: Connection!
    
    private let assessmentTable = Table("assessment")
    private let questionTable = Table("question")
    private let resultTable = Table("result")
    private let answerTable = Table("answer")
    
    private let assessmentId = SQLite.Expression<Int64>("id")
    private let abbreviation = SQLite.Expression<String>("abbreviation")
    private let name = SQLite.Expression<String>("name")
    private let description = SQLite.Expression<String>("description")
    private let instructions = SQLite.Expression<String>("instructions")
    private let frequency = SQLite.Expression<String>("frequency")
    
    private let questionId = SQLite.Expression<Int64>("id")
    private let questionAssessmentId = SQLite.Expression<Int64>("assessmentId")
    private let questionText = SQLite.Expression<String>("questionText")
    private let questionOrder = SQLite.Expression<Int64>("questionOrder")
    
    
    private let resultId = SQLite.Expression<Int64>("id")
    private let resultAssessmentId = SQLite.Expression<Int64>("assessmentId")
    private let score = SQLite.Expression<Int64>("score")
    private let impairmentCategory = SQLite.Expression<String>("impairmentCategory")
    private let dateTaken = SQLite.Expression<Date>("dateTaken")
    
    private let answerId = SQLite.Expression<Int64>("id")
    private let answerResultId = SQLite.Expression<Int64>("resultId")
    private let answerQuestionId = SQLite.Expression<Int64>("questionId")
    private let value = SQLite.Expression<Int64>("value")

    
    private init() {
        setUpDatabase()
    }
    
    private func setUpDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true)
                .first!
            
            db = try Connection("\(path)/mtracker.sqlite3")
            print("Full database path: \(path)")
            createTables()
            seedAssessmentData()
            
        } catch {
            print("Database connection failed: \(error)")
            fatalError("Cannot proceed without database connection")
        }
    }
    
    private func createTables() {
        do {
            
            try db.run(assessmentTable.create(ifNotExists: true) { t in
                t.column(assessmentId, primaryKey: .autoincrement)
                t.column(abbreviation, unique: true)
                t.column(name, unique: true)
                t.column(description)
                t.column(instructions)
                t.column(frequency)
            })
            
            try db.run(questionTable.create(ifNotExists: true) { t in
                t.column(questionId, primaryKey: .autoincrement)
                t.column(questionAssessmentId)
                t.column(questionText)
                t.column(questionOrder)
                t.foreignKey(questionAssessmentId, references: assessmentTable, assessmentId)
                
            })
            
            try db.run(resultTable.create(ifNotExists: true) { t in
                t.column(resultId, primaryKey: .autoincrement)
                t.column(resultAssessmentId)
                t.column(score)
                t.column(dateTaken)
                t.column(impairmentCategory)
                t.foreignKey(resultAssessmentId, references: assessmentTable, assessmentId)
        
            })
            
            try db.run(answerTable.create(ifNotExists: true) { t in
                t.column(answerId, primaryKey: .autoincrement)
                t.column(answerResultId)
                t.column(answerQuestionId)
                t.column(value)
                t.foreignKey(answerResultId, references: resultTable, resultId)
                t.foreignKey(answerQuestionId, references: questionTable, questionId)
            })
            
        } catch {
            print("Table creation error: \(error)")
        }
    }
    
    private func seedAssessmentData() {
        do {
            let count = try db.scalar(assessmentTable.count)
            
            if count == 0 {
                for seed in SeedData.all {
                    insertAssessmentQuestions(seed.assessment, questions: seed.questions)
                }
            }
            
        } catch {
            print("Error occurred while seeding database: \(error)")
        }
    }
    
    
    func insertAssessment(_ assessment: Assessment) -> Int64? {
        do {
            return try db.run(assessmentTable.insert(
                abbreviation <- assessment.abbreviation,
                name <- assessment.name,
                description <- assessment.description,
                instructions <- assessment.instructions,
                frequency <- assessment.frequency
            ))
            
        } catch {
            print("Error occurred while trying to insert assessment: \(error)")
            return nil
        }
    }
    
    private func insertAssessmentQuestions(_ assessment: Assessment, questions: [String]) {
        
        if let assessmentId = insertAssessment(assessment) {
            for (index, questionText) in questions.enumerated() {
                let question = Question(
                    id: nil,
                    assessmentId: assessmentId,
                    questionText: questionText,
                    questionOrder: Int64(index + 1)
                )
                _ = insertQuestion(question)
            }
        }
    }
    
    func insertQuestion(_ question: Question) -> Int64? {
        do {
            return try db.run(questionTable.insert(
                questionAssessmentId <- question.assessmentId,
                questionText <- question.questionText,
                questionOrder <- question.questionOrder
                
            ))
            
        } catch {
            print ("Error occurred while trying to insert question: \(error)")
            return nil
        }
    }
    func insertResult(_ result: Result) -> Int64? {
        do {
            let resultRowId = try db.run(resultTable.insert(
                resultAssessmentId <- result.assessmentId,
                score <- result.score,
                impairmentCategory <- result.impairmentCategory,
                dateTaken <- result.dateTaken
                
            ))
            
            for answer in result.answers {
                try db.run(answerTable.insert(
                    answerResultId <- resultRowId,
                    answerQuestionId <- answer.questionId,
                    value <- answer.value
                    
                ))
            }
            return resultRowId
            
        } catch {
            print("Error occurred while trying to insert result: \(error)")
            return nil
        }
    }
    
    func retrieveAssessments() -> [Assessment] {
        var assessments = [Assessment]()
        
        do {
            for row in try db.prepare(assessmentTable) {
                let assessment = Assessment(
                    id: row[assessmentId],
                    abbreviation: row[abbreviation],
                    name: row[name],
                    description:  row[description],
                    instructions: row[instructions],
                    frequency: row[frequency]
                )
                assessments.append(assessment)
            }
            
        } catch {
            print("Error retrieving assessments: \(error)")
        }
        return assessments
    }
    
    func retrieveAssessment(byId id: Int64) -> Assessment? {
        do {
            let query = assessmentTable.filter(self.assessmentId == id)
            
            if let row = try db.pluck(query) {
                return Assessment(
                    id: row[assessmentId],
                    abbreviation: row[self.abbreviation],
                    name: row[name],
                    description:  row[description],
                    instructions: row[instructions],
                    frequency: row[frequency]
                )
            }
            
        } catch {
            print("Error occurred while trying to retrieve assessment: \(error)")
        }
        return nil
    }
    
    func retrieveAssessmentQuestions(forAssessmentId id: Int64) -> [Question] {
        var questions = [Question]()
        
        do {
            let query = questionTable
                .filter(questionAssessmentId == id)
                .order(questionOrder)
            
            for row in try db.prepare(query) {
                let question = Question(
                    id: row[questionId],
                    assessmentId: row[questionAssessmentId],
                    questionText: row[questionText],
                    questionOrder: row[questionOrder])
                
                questions.append(question)
            }
            
        } catch {
            print("Error occurred while trying to retrieve assessment questions by ID: \(error)")
        }
        return questions
    }
    
    func retrieveResults() -> [Result] {
        var results = [Result]()
        
        do {
            for row in try db.prepare(resultTable) {
                let result = Result(
                    id: row[resultId],
                    assessmentId: row[resultAssessmentId],
                    score: row[score],
                    impairmentCategory: row[impairmentCategory],
                    dateTaken: row[dateTaken]
                )
                results.append(result)
            }
        } catch {
            print("Error retrieving results: \(error)")
        }
        
        print("Found \(results.count) results in database")
        return results
    }
}
