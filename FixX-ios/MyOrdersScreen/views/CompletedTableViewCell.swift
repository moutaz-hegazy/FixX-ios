//
//  CompletedTableViewCell.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/17/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var jobTyoeLbl: UILabel!
    @IBOutlet weak var completionDateLbl: UILabel!
    @IBOutlet weak var jobPriceLbl: UILabel!
    @IBOutlet weak var jobAddressLbl: UILabel!
    
    func viewJobOnCell(for job : Job){
        jobImageView.image = UIImage(named: job.type)
        jobTyoeLbl.text = job.type
        jobAddressLbl.text = getLocationString(from: job.location!)
        completionDateLbl.text = job.completionDate
        if(job.price != nil){
            jobPriceLbl.text = String(job.price!)
        }else{
            jobPriceLbl.text = "none"
        }
    }
    
    private func getLocationString(from location : String)->String{
        let subString = String(location[..<location.firstIndex(of: "%")!])
        if(subString.isEmpty){
            let loc = String(location[location.index(after: location.firstIndex(of: "%")!)...])
            return loc
        }else{
            return subString
        }
    }
}
