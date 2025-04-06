//
//  ResultsTableViewCell.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-06.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var assessmentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var severityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
}
