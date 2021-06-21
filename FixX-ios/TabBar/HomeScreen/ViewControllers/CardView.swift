//
//  CardView.swift
//  Graduation_Project
//
//  Created by moutaz hegazy on 6/5/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView : UIView{
    @IBInspectable var cornerRadius : CGFloat = 5
    var ofsetWidth : CGFloat = 5
    var ofsetHeight : CGFloat = 5
    
    var ofsetShadowOpacity : Float = 5
    @IBInspectable var myColour : UIColor = UIColor.systemGray6
    
    override func layoutSubviews() {
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = self.myColour.cgColor
        layer.shadowOffset = CGSize(width: self.ofsetWidth, height: self.ofsetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        layer.shadowOpacity = self.ofsetShadowOpacity
    }
}
