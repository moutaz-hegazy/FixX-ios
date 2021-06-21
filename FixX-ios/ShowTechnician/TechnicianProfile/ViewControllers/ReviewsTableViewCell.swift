//
//  ReviewsTableViewCell.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/21/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {

   
    @IBOutlet weak var reviewImage: UIImageView!
    
    @IBOutlet weak var reviewName: UILabel!
    
    @IBOutlet weak var reviewRate: CosmosView!
    
    
    @IBOutlet weak var reviewDate: UILabel!
    
    @IBOutlet weak var reviewComment: UILabel!
    
    
}
