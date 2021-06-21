//
//  ServiceCollectionViewCell.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/5/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgServicePhoto : UIImageView!
    @IBOutlet weak var labelServiceName : UILabel!
    
    
    func setupCell(photo : UIImage , name : String){
        imgServicePhoto.image = photo
        labelServiceName.text = name
    }
    
}
