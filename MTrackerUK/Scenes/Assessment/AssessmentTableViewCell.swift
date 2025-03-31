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
    
    
    private var question: Question?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with question: Question, index: Int) {
        self.question = question
        questionNumberLabel.text = "Question \(index + 1)"
        questionLabel.text = question.questionText
    }
}
