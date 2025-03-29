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
    private let questionOrder = SQLite.Expression<Int>("questionOrder")
    
    
    private let resultId = SQLite.Expression<Int64>("id")
    private let resultAssessmentId = SQLite.Expression<Int64>("assessmentId")
    private let score = SQLite.Expression<Int>("score")
    private let impairmentCategory = SQLite.Expression<String>("impairmentCategory")
    private let dateTaken = SQLite.Expression<Date>("dateTaken")
    
    private let answerId = SQLite.Expression<Int64>("id")
    private let answerResultId = SQLite.Expression<Int64>("resultId")
    private let answerQuestionId = SQLite.Expression<Int64>("questionId")
    private let value = SQLite.Expression<Int>("value")

    
    private init() {
        setUpDatabase()
    }
    
    private func setUpDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true)
                .first!
            
            db = try Connection("\(path)/mtracker.sqlite3")
            createTables()
            insertAssessmentData()
            
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
    
    private func insertAssessmentData() {
        do {
            
            let count = try db.scalar(assessmentTable.count)
            if count == 0 {
                
                let gad7Assessment = Assessment(
                    id: nil,
                    abbreviation: "GAD-7",
                    name: "General Anxiety Disorder 7",
                    description: "This easy-to-use self-administered questionnaire is used as a screening tool and severity measure for generalized anxiety disorder",
                    instructions: "Over the last two weeks, how often have you been bothered by any of the following problems?",
                    frequency: "Once every two weeks"
                    
                )
                
                let phqAssessment = Assessment(
                    id: nil,
                    abbreviation: "PHQ-9",
                    name: "Patient Health Questionnaire 9",
                    description: "This short, self-administered questionnaire is used as a screening tool and severity measure for major depressive disorder",
                    instructions: "Over the last two weeks, how often have you been bothered by any of the following problems?",
                    frequency: "Once every two weeks"
                    
                    )
                
                if let gadId = insertAssessment(gad7Assessment) {
                    
                    let gadQuestions = [
                        "Feeling nervous, anxious, or on edge",
                        "Not being able to stop or control worrying",
                        "Worrying too much about different things",
                        "Trouble relaxing",
                        "Being so restless that it's hard to sit still",
                        "Becoming easily annoyed or irritable",
                        "Feeling afraid as if something awful might happen"
                    ]
                    
                    for(index, questionText) in gadQuestions.enumerated() {
                        let question = Question(
                            id: nil,
                            assessmentId: gadId,
                            questionText: questionText,
                            questionOrder: index + 1
                        )
                        _ = insertQuestion(question)
                    }
                }
                
                if let phqId = insertAssessment(phqAssessment) {
                    
                    let phqQuestions = [
                        "Little interest or pleasure in doing things?",
                        "Feeling down, depressed, or hopeless?",
                        "Trouble falling or staying asleep or sleeping too much?",
                        "Feeling tired or having little energy",
                        "Poor appetite or overeating?",
                        "Feeling bad about yourself - or that you are a failure or have let yourself or your family down?",
                        "Trouble concentrating on things, such as reading the newspaper or watching television?",
                        "Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?",
                        "Thoughts that you would be better off dead, or of hurting yourself in some way?"
                    ]
                    
                    for(index, questionText) in phqQuestions.enumerated() {
                        let question = Question(
                            id: nil,
                            assessmentId: phqId,
                            questionText: questionText,
                            questionOrder: index + 1
                        )
                       _ = insertQuestion(question)
                    }
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
}
