//
//  RightMessageCustomCell.swift
//  Fixawy
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class RightMessageCustomCell: UITableViewCell {
    
    @IBOutlet weak var R_Avatar: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var imageLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayMessage(_ message : ChatMessage){
        if let image = HomeScreenViewController.USER_OBJECT?.profilePicture?.second, !image.isEmpty{
            imageLbl.isHidden = true
            R_Avatar.isHidden = false
            R_Avatar.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            imageLbl.isHidden = false
            R_Avatar.isHidden = true
            imageLbl.text = HomeScreenViewController.USER_OBJECT?.name.first?.uppercased()
        }
        
        msgLbl.text = message.text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        R_Avatar.image = nil
        msgLbl.text = nil
        imageLbl.isHidden = true
    }
    
}
