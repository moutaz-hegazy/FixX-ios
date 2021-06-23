//
//  BidderTableViewCell.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/24/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos

class BidderTableViewCell: UITableViewCell {

    @IBOutlet weak var bidderImageView: UIImageView!
    @IBOutlet weak var bidderNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bidderRatingBar: CosmosView!
    

    @IBAction func acceptBtnPressed(_ sender: UIButton) {
        
        
        
    }
    @IBAction func chatBtnPressed(_ sender: UIButton) {
    }
    @IBAction func callBtnPressed(_ sender: UIButton) {
    }
}
