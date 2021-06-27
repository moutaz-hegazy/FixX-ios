//
//  BidderTableViewCell.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/24/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class BidderTableViewCell: UITableViewCell {

    @IBOutlet weak var bidderImageView: UIImageView!
    @IBOutlet weak var bidderNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bidderRatingBar: CosmosView!
    
    var price : String?
    var tech : Technician?
    var onAcceptHandler:((String,Technician) -> ())?
    var onChatHandler : ((Technician?)->())?

    @IBAction func acceptBtnPressed(_ sender: UIButton) {
        
        onAcceptHandler?(price!,tech!)
        
    }
    @IBAction func chatBtnPressed(_ sender: UIButton) {
        onChatHandler?(tech)
    }
    @IBAction func callBtnPressed(_ sender: UIButton) {
    }
    
    func displayBidderData(for bidder: Technician, with price:String){
        bidderRatingBar.settings.updateOnTouch = false
        bidderRatingBar.settings.fillMode = .half
        self.price = price
        tech = bidder
        bidderRatingBar.settings.updateOnTouch = false
        if let image = bidder.profilePicture?.second, !image.isEmpty{
            bidderImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            //code for image lbl.
        }
        bidderNameLbl.text = bidder.name
        priceLbl.text = price
        bidderRatingBar.rating = bidder.rating ?? 2.5
    }
}
