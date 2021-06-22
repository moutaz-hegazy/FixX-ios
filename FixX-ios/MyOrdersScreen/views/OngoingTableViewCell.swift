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

    func viewJobOnCell(for job : Job){
        jobImageView.image = UIImage(named: job.type)
        jobTypeLbl.text = job.type
        jobAddressLbl.text = getLocationString(from: job.location!)
        jobDateLbl.text = job.date
        jobFromTimeLbl.text = job.fromTime ?? "none"
        jobToTimeLbl.text = job.toTime ?? "none"
        if(job.price != nil){
            jobPriceLbl.text = String(job.price!)
        }else{
            jobPriceLbl.text = "none"
        }
        
        if(job.status == "OnRequest"){
            jobStatusLbl.text = "On Request"
            jobStatusLbl.textColor = .green
        }else{
            jobStatusLbl.text = "Accepted"
            jobStatusLbl.textColor = .blue
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
