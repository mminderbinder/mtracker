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
    private var db: Connection?
    
    private let assessmentTable = Table("assessment")
    private let questionTable = Table("question")
    private let resultsTable = Table("results")
    
    private let assessmentId = SQLite.Expression<Int>("assessmentId")
    private let shortName = SQLite.Expression<String>("shortName")
    private let name = SQLite.Expression<String>("name")
    private let description = SQLite.Expression<String>("description")
    private let instructions = SQLite.Expression<String>("instructions")
    private let frequency = SQLite.Expression<String>("frequency")
    
    private let questionId = SQLite.Expression<Int>("questionId")
    private let questionAssessmentId = SQLite.Expression<Int>("assessmentId")
    private let questionText = SQLite.Expression<String>("questionText")
    private let questionOrder = SQLite.Expression<Int>("questionOrder")
    
    private let resultId = SQLite.Expression<Int>("resultId")
    private let resultAssessmentId = SQLite.Expression<Int>("assessmentId")
    private let score = SQLite.Expression<Int>("score")
    private let dateTaken = SQLite.Expression<Date>("dateTaken")
    private let answers = SQLite.Expression<String>("answers")
    
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
            
        } catch {
            print("Database connection failed: \(error)")
        }
    }
    
    private func createTables() {
        do {
            
            try db?.run(assessmentTable.create(ifNotExists: true) { t in
                t.column(assessmentId, primaryKey: .autoincrement)
                t.column(shortName, unique: true)
                t.column(name, unique: true)
                t.column(description)
                t.column(instructions)
                t.column(frequency)
            })
            
            try db?.run(questionTable.create(ifNotExists: true) { t in
                t.column(questionId, primaryKey: .autoincrement)
                t.column(questionAssessmentId)
                t.column(questionText)
                t.column(questionOrder)
                t.foreignKey(questionAssessmentId, references: assessmentTable, assessmentId)
                
            })
            
            try db?.run(resultsTable.create(ifNotExists: true) { t in
                t.column(resultId, primaryKey: .autoincrement)
                t.column(resultAssessmentId)
                t.column(score)
                t.column(dateTaken)
                t.column(answers)
                t.foreignKey(resultAssessmentId, references: assessmentTable, assessmentId)
        
            })
            
        } catch {
            print("Table creation error: \(error)")
        }
    }
    
    private func insertAssessment() {
        
    }
    
    private func insertAssessmentData() {
        do {
            var count = try db?.scalar(assessmentTable.count)
            
            if count == 0 {
                let gad7 = Assessment(
                    assessmentId: nil,
                    shortName: "GAD-7",
                    name: "General Anxiety Disorder 7",
                    description: "This easy-to-use self-administered questionnaire is used as a screening tool and severity measure for generalized anxiety disorder",
                    instructions: "Over the last two weeks, how often have you been bothered by any of the following problems?",
                    frequency: "Once every two weeks"
                    
                )
            }
        } catch {
            print("Error seeding data: \(error)")
        }

        
    }
}
