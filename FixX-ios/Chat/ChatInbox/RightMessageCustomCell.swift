//
//  RightMessageCustomCell.swift
//  Fixawy
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class RightMessageCustomCell: UITableViewCell {
    
    @IBOutlet weak var R_Constraints: NSLayoutConstraint!
    @IBOutlet weak var R_Avatar: UIImageView!
    @IBOutlet weak var R_Message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //R_Message.translatesAutoresizingMaskIntoConstraints = true
        //R_Constraints.constant = self.R_Message.contentSize.height
        //R_Message.sizeToFit()
        R_Message.isScrollEnabled = false
        R_Message.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
