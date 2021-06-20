//
//  MyAddressesTableViewCell.swift
//  Locations
//
//  Created by Esraa Gohar on 6/16/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit

class MyAddressesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
