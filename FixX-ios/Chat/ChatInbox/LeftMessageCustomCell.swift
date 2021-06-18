//
//  LeftMessageCustomCell.swift
//  Fixawy
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class LeftMessageCustomCell: UITableViewCell {
    
    @IBOutlet weak var L_Constraints: NSLayoutConstraint!
    @IBOutlet weak var L_Avatar: UIImageView!
    @IBOutlet weak var L_Message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //L_Message.translatesAutoresizingMaskIntoConstraints = true
        //L_Constraints.constant = self.L_Message.contentSize.height
        L_Message.sizeToFit()
        L_Message.isScrollEnabled = false
        L_Message.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
