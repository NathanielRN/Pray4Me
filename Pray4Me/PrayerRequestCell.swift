//
//  PrayerRequestCell.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-05.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class PrayerRequestCell: UITableViewCell {

	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var requestLabel: UILabel!
	@IBOutlet weak var userAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
