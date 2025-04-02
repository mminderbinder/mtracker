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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

    }
    func configure(with question: Question, index: Int) {
        self.question = question
        questionNumberLabel.text = "Question \(index + 1)"
        questionLabel.text = question.questionText
    }
    
    @objc private func segmentedControlValueChanged() {
        let value = segmentedControl.selectedSegmentIndex
        valueChanged?(questionIndex, value)
    }
}
