//
//  HomeTableViewCell.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-03-28.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func didTouchStartButton(for assessment: Assessment)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContainerView: UIView!
    
    @IBOutlet weak var abbreviationLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    weak var delegate: HomeTableViewCellDelegate?
    
    private var assessment: Assessment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCardView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpCardView() {
        cardContainerView.clipsToBounds = false
        cardContainerView.layer.cornerRadius = 10
        cardContainerView.backgroundColor = UIColor.systemBackground

        cardContainerView.layer.shadowColor = UIColor.label.cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainerView.layer.shadowRadius = 4
        cardContainerView.layer.shadowOpacity = 0.08
        cardContainerView.layer.masksToBounds = false

        cardContainerView.layer.borderWidth = 0.3
        cardContainerView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    func configure(with assessment: Assessment) {
        self.assessment = assessment
        abbreviationLabel.text = assessment.abbreviation
        nameLabel.text = assessment.name
        descriptionLabel.text = assessment.description
        frequencyLabel.text = assessment.frequency
    
    }
    
    @IBAction func startButtonTouched(_ sender: Any) {
        if let assessment = assessment {
            delegate?.didTouchStartButton(for: assessment)
            
        }
    }
}
