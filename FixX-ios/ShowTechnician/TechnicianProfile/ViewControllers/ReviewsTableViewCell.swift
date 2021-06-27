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
    @IBOutlet weak var imageLbl: UILabel!
    @IBOutlet weak var replyTitleLbl: UILabel!
    @IBOutlet weak var replyContentLbl: UILabel!
    
    func displayComment(_ comment : Comment){
        reviewRate.settings.updateOnTouch = false
        reviewRate.settings.fillMode = .half
        if let image = comment.profilePicture, !image.isEmpty{
            imageLbl.isHidden = true
            reviewImage.isHidden = false
            reviewImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            reviewImage.isHidden = true
            imageLbl.isHidden = false
            imageLbl.text = comment.username.first?.uppercased()
        }
        
        reviewName.text = comment.username
        reviewRate.rating = comment.rating ?? 2.5
        reviewDate.text = comment.date
        reviewComment.text = comment.commentContent
        
        if let reply = comment.reply, !reply.isEmpty{
            replyTitleLbl.text = "Reply :"
            replyContentLbl.text = reply
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        imageLbl.text = nil
        reviewName.text = nil
        reviewRate.rating = 0
        reviewDate.text = nil
        reviewComment.text = nil
        replyTitleLbl.text = nil
        replyContentLbl.text = nil
    }
    
}
