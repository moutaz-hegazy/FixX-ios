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
    @IBOutlet weak var techImageLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var bookBtn: UIButton!
    
    var techData : Technician?
    
    var techSelectedHandle : ((Technician?)->())?
    
    func displayTechData(tech : Technician){
        techRating.settings.updateOnTouch = false
        techData = tech
        if let pic = tech.profilePicture, !pic.second.isEmpty{
            techImageLbl.isHidden = true
            techImage.sd_setImage(with: URL(string: pic.second), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            techImageLbl.layer.masksToBounds = true
            techImageLbl.text = tech.name.first?.uppercased()
        }
        techName.text = tech.name
        techNoOfJobs.text = String(tech.jobsCount)
        techNoOfReviews.text = String(tech.reviewCount)
        techRating.rating = tech.rating ?? 2.5
    }

    @IBAction func bookBtnPressed(_ sender: UIButton){
        spinner.isHidden = false
        spinner.startAnimating()
        techSelectedHandle?(techData)
    }
}
