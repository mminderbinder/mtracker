//
//  DetailedResultsTableViewCell.swift
//  MTrackerUK
//
//  Created by Shawn Perron on 2025-04-04.
//

import UIKit

class DetailedResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var severityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
