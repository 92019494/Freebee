//
//  FreebeeTableViewCell.swift
//  Freebee
//
//  Created by Anthony on 3/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class FreebeeTableViewCell: UITableViewCell  {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var businessLabel: UILabel!
    
    @IBOutlet weak var giveawayLabel: UILabel!
    @IBOutlet weak var closingDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
