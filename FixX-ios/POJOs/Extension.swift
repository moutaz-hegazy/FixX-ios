//
//  Extension.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/16/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class Extension : Codable{
    var extId : String?
    var images : [StringPair]?
    var description : String?
    var price : Int?
    
    init() {}
    init(extId : String?, images : [StringPair]?, description : String?, price : Int?) {
        self.extId = extId
        self.images = images
        self.description = description
        self.price = price
        
    }
}
