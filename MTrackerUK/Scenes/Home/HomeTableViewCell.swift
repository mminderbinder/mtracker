//
//  HomeTableViewCell.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-28.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContainerView: UIView!
    
    @IBOutlet weak var abbreviationLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with assessment: Assessment) {
        abbreviationLabel.text = assessment.abbreviation
        nameLabel.text = assessment.name
        descriptionLabel.text = assessment.description
        frequencyLabel.text = assessment.frequency
    }
}
