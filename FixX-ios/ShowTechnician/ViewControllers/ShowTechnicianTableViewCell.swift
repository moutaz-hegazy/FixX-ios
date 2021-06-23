//
//  ShowTechnicianTableViewCell.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/17/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class ShowTechnicianTableViewCell: UITableViewCell {
    
    @IBOutlet weak var techImage: UIImageView!
    @IBOutlet weak var techName: UILabel!
    @IBOutlet weak var techNoOfJobs: UILabel!
    @IBOutlet weak var techNoOfReviews: UILabel!
    @IBOutlet weak var techRating: CosmosView!
    
    
    var techSelectedHandle : (()->())?
    
    func displayTechData(tech : Technician){
        
        if let pic = tech.profilePicture, !pic.second.isEmpty{
            techImage.sd_setImage(with: URL(string: pic.second), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            // here image lbl.
        }
        techName.text = tech.name
        techNoOfJobs.text = String(tech.jobsCount)
        techNoOfReviews.text = String(tech.reviewCount)
        techRating.rating = tech.rating ?? 2.5
    }

    @IBAction func bookBtnPressed(_ sender: UIButton){
        print("book pressed")
    }
}
