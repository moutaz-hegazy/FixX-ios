//
//  ShowTechnicianTableViewCell.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/17/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos

class ShowTechnicianTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TechImage: UIImageView!
    
    @IBOutlet weak var TechName: UILabel!
        
    @IBOutlet weak var TechNoOfJobs: UILabel!
    
    
    @IBOutlet weak var TechNoOfReviews: UILabel!
    
    @IBOutlet weak var BookButton: UIButton!
    
    @IBOutlet weak var ReviewsLabel: UILabel!
    @IBOutlet weak var DoneJobsLabel: UILabel!
    
    @IBOutlet weak var TechRating: CosmosView!
    
        
    //    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
