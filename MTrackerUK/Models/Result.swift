//
//  Result.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-27.
//

import Foundation

struct Result {
    var id: Int64?
    let assessmentId: Int64
    let score: Int
    let impairmentCategory: String
    let dateTaken: Date
    var answers: [Answer] = []
}
