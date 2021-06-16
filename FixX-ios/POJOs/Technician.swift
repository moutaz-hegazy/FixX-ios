//
//  Technician.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/15/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import Foundation

class Technician : Person{
    var jobTitle: String?
    var workLocations: [String]?
    var rating: Double?
    var monthlyRating: Int?
    var jobsCount : Int = 0
    var reviewCount:Int = 0
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        
    }
}
