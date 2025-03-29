//
//  SeedData.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-29.
//

import Foundation

struct SeedAssessment {
    let assessment: Assessment
    let questions: [String]
}

struct SeedData {
    static let all: [SeedAssessment] = [
        
        SeedAssessment(
            assessment: Assessment(
                id: nil,
                abbreviation: "GAD-7",
                name: "General Anxiety Disorder 7",
                description: "This easy-to-use self-administered questionnaire is used as a screening tool and severity measure for generalized anxiety disorder",
                instructions: "Over the last two weeks, how often have you been bothered by any of the following problems?",
                frequency: "Once every two weeks"
            ),
            questions: [
                "Feeling nervous, anxious, or on edge",
                "Not being able to stop or control worrying",
                "Worrying too much about different things",
                "Trouble relaxing",
                "Being so restless that it's hard to sit still",
                "Becoming easily annoyed or irritable",
                "Feeling afraid as if something awful might happen"
            ]
        ),
        
        SeedAssessment(
            assessment: Assessment(
                id: nil,
                abbreviation: "PHQ-9",
                name: "Patient Health Questionnaire 9",
                description: "This short, self-administered questionnaire is used as a screening tool and severity measure for major depressive disorder",
                instructions: "Over the last two weeks, how often have you been bothered by any of the following problems?",
                frequency: "Once every two weeks"
            ),
            questions: [
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
        )
    ]
}
