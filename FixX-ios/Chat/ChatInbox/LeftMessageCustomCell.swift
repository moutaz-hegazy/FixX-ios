//
//  LeftMessageCustomCell.swift
//  Fixawy
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class LeftMessageCustomCell: UITableViewCell {
    
    @IBOutlet weak var L_Avatar: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var imageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayMessage(_ message : ChatMessage,imgStr : String?,name : String){
        if let image = imgStr, !image.isEmpty{
            imageLbl.isHidden = true
            L_Avatar.isHidden = false
            L_Avatar.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            imageLbl.isHidden = false
            L_Avatar.isHidden = true
            imageLbl.text = name.first?.uppercased()
        }
        
        msgLbl.text = message.text
        print("id >> \(message.fromId) << text >> \(message.text)")
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        L_Avatar.image = nil
        msgLbl.text = nil
        imageLbl.isHidden = true
    }
    
}
