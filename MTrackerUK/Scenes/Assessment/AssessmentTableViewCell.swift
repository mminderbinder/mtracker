//
//  AssessmentTableViewCell.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-30.
//

import UIKit

class AssessmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var question: Question?
    var questionIndex : Int = 0
    
    var valueChanged: ((Int, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func configure(with question: Question, index: Int, selectedAnswer: Int?) {
        self.question = question
        self.questionIndex = index
        questionNumberLabel.text = "Question \(index + 1)"
        questionLabel.text = question.questionText
        
        if let answer = selectedAnswer {
            segmentedControl.selectedSegmentIndex = answer
        } else {
            segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        let value = segmentedControl.selectedSegmentIndex
        print("Value changed for question \(questionIndex): \(value)")
        valueChanged?(questionIndex, value)
    }
}
