//
//  OngoingTableViewCell.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class OngoingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var jobAddressLbl: UILabel!
    @IBOutlet weak var jobDateLbl: UILabel!
    @IBOutlet weak var jobFromTimeLbl: UILabel!
    @IBOutlet weak var jobToTimeLbl: UILabel!
    @IBOutlet weak var jobPriceLbl: UILabel!
    @IBOutlet weak var jobStatusLbl: UILabel!
    
    
    @IBAction func optionsBtnClicked(_ sender: UIButton) {
        
    }
}
